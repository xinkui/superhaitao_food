class Users::ManagerController < ApplicationController
  before_action :set_user, :only => [:edit, :update]
  before_action :set_user_admin, only: [:show_admin, :update_admin, :edit_admin, :change_state_admin, :add_share_point]

  layout lambda { |controller| current_user.role == 'admin' ? 'admin' : 'application' }

  def edit

  end

  def update
    @user.phone = user_params[:phone]
    @user.weibo = user_params[:weibo]
    @user.weixin = user_params[:weixin]
    unless @user.is_add_reg_point
      if @user.phone != '' && @user.weibo != '' && @user.weixin != ''
        @user.point += 20
        @user.is_add_reg_point = true
      end
    end
    @user.save
    respond_to do |format|
      flash.now[:success] = t('message.global.update_successfully')
      format.html { render action: 'edit' }
    end
  end

  def index_admin
    authorize! :manage, current_user.role != 'admin'
    if params[:q] != nil
      @search_state_eq = params[:q][:state_eq]
      @search_role_eq = params[:q][:role_eq]
      @search_name_cont = params[:q][:name_cont]
      @search_email_cont = params[:q][:email_cont]
    end
    @search = User.search(params[:q])
    @users = @search.result.order('created_at desc').paginate( :page => params[:page], :per_page => 15 )
  end

  def new_admin
    authorize! :manage, current_user.role != 'admin'
    @user = User.new
  end

  def create_admin
    authorize! :manage, current_user.role != 'admin'
    @user = User.new(user_params_admin)
    @user.role = 'admin'
    @user.confirmed_at = DateTime.now
    if @user.save
      flash[:notice] = t('message.global.created_successfully')
      redirect_to action: 'show_admin', id: @user.id
    else
      render action: 'new_admin'
    end
  end

  def add_share_point
    authorize! :manage, current_user.role != 'admin'
    @user.point += 10
    if params['share'] == 'weixin'
      @user.is_share_weixin = true
    elsif params['share'] == 'weibo'
      @user.is_share_weibo = true
    end
    if @user.save
      flash[:notice] = '积分增加成功!'
    else
      flash[:alert] = '积分增加失败,请重新操作!'
    end
    redirect_to action: :index_admin
  end

  def show_admin
    authorize! :manage, current_user.role != 'admin'
  end

  def update_admin
    authorize! :manage, current_user.role != 'admin'
    if @user.update(user_params_admin)
      flash[:success] = t('message.global.update_successfully')
      redirect_to search_users_users_manager_index_path
    else
      render action: 'edit_admin'
    end
  end

  def edit_admin
    authorize! :manage, current_user.role != 'admin'
  end

  def change_state_admin
    authorize! :manage, current_user.role != 'admin'
    @user.change_state
    @user.save
    if @user.state == 'locked'
      flash[:notice] = t('message.user.locked_success')
    else
      flash[:notice] = t('message.user.actived_success')
    end
    redirect_to search_users_users_manager_index_path
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end

    def set_user_admin
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:phone, :weixin, :weibo, :is_add_reg_point)
    end

    def user_params_admin
      params.require(:user).permit(:name, :email, :phone, :password,
                                   :password_confirmation, :point, :balance)
    end

end