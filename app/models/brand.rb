class Brand < ActiveRecord::Base

  has_many :skus, dependent: :restrict

  default_scope -> { order('name_cn') }

  validates :name_en, :name_cn, presence: true, uniqueness: true

end
