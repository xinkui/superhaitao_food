class Receiver < ActiveRecord::Base
  #add audit support
  include Auditable

  belongs_to :user
  belongs_to :city
  belongs_to :province
  belongs_to :district

  scope :by_user, lambda { |user| where( user: user) }
  scope :by_active_true, -> { where( active: true ) }

  validates :name, :city_id, :province_id, :district_id, :address, :zip_code, :phone, :presence => true
  validates :zip_code, numericality: true


  def show_receiver_message
    "#{name},  #{phone}, #{province.name} #{city.name} #{district.name} #{address}, #{zip_code}"
  end

  def get_receiver_address
    "中国#{province.name}#{city.name}#{district.name}#{address}"
  end

end
