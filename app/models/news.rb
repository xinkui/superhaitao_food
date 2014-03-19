class News < ActiveRecord::Base

  validates :title, :summary, :content, presence: true
end
