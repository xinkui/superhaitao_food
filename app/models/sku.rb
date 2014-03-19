class Sku < ActiveRecord::Base
  #add audit support
  include Auditable

  belongs_to :brand
  belongs_to :category

  before_save :cal_volume

  before_update :cal_volume

  before_destroy :validate_exit_items?

  scope :by_barcode, lambda { |barcode| where(barcode: barcode) }

  validates :name_en, :name, :length, :width, :height, :actual_weight, :purchase_price, :barcode, :brand, :category, presence: true
  validates :length, :width, :height, :actual_weight, :purchase_price, numericality: true
  validates_uniqueness_of :name, :name_en, :barcode

  def cal_volume
    self.volume = self.length * self.width * self.height
  end

  def show_made_in_germany
    if self.made_in_germany
      '是'
    else
      '否'
    end
  end

  def validate_exit_items?
    if Item.where(sku_id: self.id).size > 0
      errors[:base] << '已经有关联货品，不能删除!'
      false
    end
  end

end
