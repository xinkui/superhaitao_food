class Order < ActiveRecord::Base

  include HasBarcode

  #add audit support
  include Auditable

  belongs_to :user
  has_many :items
  belongs_to :receiver
  has_many :value_added_services

  scope :by_user_id, lambda { |user_id| where(user_id: user_id) }

  before_create :set_number

  state_machine :initial => :unpaid do

    before_transition :unpaid => :pending_audit do |order, transition|
      total_price = transition.args[0]
      trade_point = transition.args[1]
      user = User.find( order.user_id )
      user.point -= [trade_point, total_price].min
      user.point += (total_price / 100.0).round(2)
      user.save!
      order.total_price = total_price
      order.traded_at = DateTime.now
      order.save!
      order.items.each do |item|
        item.change_state_pending_audit
        item.save!
      end
      if user.recommended != nil && user.recommended != '' && Order.by_user_id(order.user_id).size == 1
        user_recommended = User.by_name(user.recommended).first
        user_recommended.point += 20
        user_recommended.save!
      end
    end

    before_transition :pending_audit => :wait_ship do |order, transition|
      order.is_generate_waybill = false
      order.international_waybill_company = transition.args[0]
      order.generate_receiver_pdf
    end

    before_transition :wait_ship => :completed do |order, transition|
      order.international_waybill_no = transition.args[0]
      order.completed_at = DateTime.now
      order.items.each { |item| item.change_state_completed }
    end

    before_transition :unpaid => :canceled do |order|
      order.items.each { |item| item.change_state_cancel }
    end

    event :change_state_pending_audit do
      transition :unpaid => :pending_audit
    end
    event :change_state_wait_ship do
      transition :pending_audit => :wait_ship
    end
    event :change_state_completed do
      transition :wait_ship => :completed
    end
    event :change_state_cancel do
      transition :unpaid => :canceled
    end
  end

  def add_share_point(share_type)
    begin
      Order.transaction do
        user = self.user
        user.point += 10
        if share_type == 'weixin'
          self.is_share_weixin = true
        elsif share_type == 'weibo'
          self.is_share_weibo = true
        end
        user.save!
        self.save!
        true
      end
    rescue Exception => errors
      false
    end
  end

  has_barcode :barcode,
              :outputter => :svg,
              :type => :code_128,
              :value => Proc.new { |p| "#{p.user.id} #{p.number}" }

  def generate_receiver_pdf
    self.receiver_pdf_path = "receivers_pdf/#{Time.now.strftime('%Y%m%d').to_s}"
    mkdir_pdf_path
    output = GeneratePdf.new.generate_receiver_pdf(self)
    File.open(self.get_receiver_pdf_url, 'wb') do |f|
      f.write(output)
      f.close
    end
  end

  def mkdir_pdf_path
    root_path = "#{Rails.root}/app/assets/pdfs/"
    unless File.exist?(root_path + self.receiver_pdf_path)
      Dir.mkdir(root_path + self.receiver_pdf_path)
    end
  end

  def get_receiver_pdf_url
    "#{Rails.root}/app/assets/pdfs/#{receiver_pdf_path}/#{user.id}_#{number}.pdf"
  end

  def get_items_weight
    items.sum(:weight)
  end

  def set_number
    self.number = DateTime.now.strftime('%Y%m%d%H%M%S%L')
  end

  def cal_warehouse_charges
    result = 0
    items.each do |item|
      date = (Time.now - item.created_at.to_datetime).to_i/1.day
      if date >= 45
        result += (date - 45) * 10
      end
    end
    result
  end

  def cal_firm_package_charges
    total_weight = get_items_weight
    if total_weight <= 7
      0
    elsif total_weight > 7 && total_weight <= 15
      20
    else
      50
    end
  end

  def create_value_added_services(firm_package, balloon_num)
    value_added_services.each do |value_added_service|
      value_added_service.delete
    end
    warehouse_charges = cal_warehouse_charges
    if warehouse_charges > 0
      self.value_added_services.create(name: :warehouse_charges, price: warehouse_charges)
    end
    if firm_package
      self.value_added_services.create(name: :firm_package, price: cal_firm_package_charges)
    end
    unless balloon_num.empty?
      self.value_added_services.create(name: :balloon, price: balloon_num.to_i * 5)
    end
  end

  def get_barcode
    "#{user.id} #{number}"
  end

  def get_state
    case state
      when 'unpaid' then '未付款'
      when 'pending_audit'  then '待审核'
      when 'wait_ship'  then  '待发货'
      when 'completed' then '已完成'
      when 'canceled' then '已取消'
    end
  end

  def is_all_items_wait_ship
    state = true
    items.each do |item|
      if item.state != 'wait_ship'
        state = false
      end
    end
    state
  end
end
