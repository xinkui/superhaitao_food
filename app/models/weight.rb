class Weight < ActiveRecord::Base
  #add audit support
  include Auditable

  has_many :prices, dependent: :restrict

  default_scope -> { order('weight asc') }

  validates :weight, presence: true, numericality: true, uniqueness: true
end
