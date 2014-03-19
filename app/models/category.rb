class Category < ActiveRecord::Base

  has_many :skus, dependent: :restrict

  default_scope -> { order('name_cn') }

  validates :name_cn, :name_en, presence: true, uniqueness: true

end
