#增加数据操作日志，审计功能
module Auditable
  extend ActiveSupport::Concern


  included do
    include PublicActivity::Model
    tracked owner: ->(controller, model) {controller.try(:current_user) }
  end
end