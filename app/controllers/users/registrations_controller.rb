class Users::RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :recommended)
  end

  private :sign_up_params

end