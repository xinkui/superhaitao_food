class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :async, :validatable

  #add audit support
  include PublicActivity::Model
  tracked

  has_many :orders
  has_many :items

  scope :by_name, lambda { |name| where(name: name) }

  validates :name, :presence => true, :uniqueness => true, format: { with: /\A[a-zA-Z0-9_]*\z/, message: '用户名请用英文字母和数字' }
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates_length_of :name, :maximum => 15
  validate :check_recommended, on: :create

  state_machine :initial => :active do
    event :change_state do
      transition :active => :locked, :locked => :active
    end
  end

  def check_recommended
    if recommended != nil && recommended != ''
      user = User.by_name(recommended).first
      errors.add(:recommended, '推荐人不存在') unless user
    end
  end

  def is_admin
    if self.role == 'admin'
      true
    else
      false
    end
  end

  def get_role
    case self.role
      when 'admin'  then '管理员'
      when 'buyers' then '买家'
      else ' '
    end
  end

  def get_state
    case self.state
      when 'active' then  '激活'
      when 'locked' then  '冻结'
      else ' '
    end
  end
end
