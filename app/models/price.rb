class Price < ActiveRecord::Base

  #add audit support
  include Auditable

  belongs_to :weight

  default_scope -> { order('price') }
  scope :by_weight, lambda {|weight| joins(:weight).where(weights: {weight: weight.ceil}).try(:first).try(:price) || 0.0}

  validates :weight, :price, presence: true
  validates_uniqueness_of :weight_id

end
