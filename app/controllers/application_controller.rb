class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  respond_to :html
  before_filter :authenticate_user!, unless: :devise_controller?

  # 使cancan插件支持rails4
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cancan_error_shipping_buyer_helps_path
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    @super_str = super
    # 如果@super_str的长度大于1，表示如果原来有输入url的话登陆后直接跳转到url
    if @super_str.length > 1
      @super_str
    elsif current_user.role != 'admin'
      current_user.sign_in_count == 1 ? edit_users_manager_path(current_user) : shipping_buyer_items_path
    else
      shipping_admin_items_path
    end
  end

end
