# encoding: utf-8
class Item < ActiveRecord::Base
  #add audit support
  include Auditable

  belongs_to :user
  belongs_to :order
  belongs_to :sku

  default_scope -> { order('created_at desc') }
  scope :by_current_user, lambda { |user| where(user: user) }
  scope :by_status, lambda { |state| where(state: state) }
  scope :by_order_id, lambda { |order_id| where( order_id: order_id) }

  validates :user, :weight, :express_name_internal, :express_no_internal, :sku, :presence => true
  before_destroy :confirm_order_is_null

  state_machine :initial => :new do

    event :change_state_created_order do
      transition :new => :created_order
    end
    event :change_state_pending_audit do
      transition :created_order => :pending_audit
    end
    event :change_state_wait_ship do
      transition :pending_audit => :wait_ship
    end
    event :change_state_completed do
      transition :wait_ship => :completed
    end
    event :change_state_cancel do
      transition :created_order => :new
    end
  end

  def self.count_new_items_by_user(user)
    if user
      Item.by_current_user(user).by_status(:new).size
    else
      0
    end
  end

  def get_state
    case state
      when 'new' then '新增'
      when 'created_order' then '生成订单'
      when 'pending_audit' then '待审核'
      when 'wait_ship' then '待发货'
      when 'completed' then '已完成'
    end
  end

  #can not delete when order is not null
  def confirm_order_is_null
    if self.order
      errors[:base] << '已经有关联订单，不能删除!'
      false
    end
  end
end
