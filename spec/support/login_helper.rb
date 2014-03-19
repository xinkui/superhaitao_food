module ControllerLoginHelper
  def login_user
    before(:each) do
      #@request.env["devise.mapping"] = Devise.mappings[:user]
      @user ||= FactoryGirl.create(:user)
      sign_in @user
    end
  end

  def login_admin
    before(:each) do
      #@request.env["devise.mapping"] = Devise.mappings[:user]
      @admin ||= FactoryGirl.create(:admin)
      sign_in @admin
    end
  end
end

module RequestLoginHelper
  def login_user
    before(:each) do
      @user ||= FactoryGirl.create(:user)
      post_via_redirect user_session_path, 'user[name]' => @user.name, 'user[password]' => @user.password
    end
  end

  def login_admin
    before(:each) do
      @admin ||= FactoryGirl.create(:admin)
      post_via_redirect user_session_path, 'user[name]' => @admin.name, 'user[password]' => @admin.password
    end
  end
end

module FeatureLoginHelper
  def login_user
    before(:each) do
      @user ||= FactoryGirl.create(:user)
      login_as(@user, scope: :user)
    end
  end

  def login_admin
    before(:each) do
      @admin ||= FactoryGirl.create(:admin)
      loing_as(@admin, scope: :user)
    end
  end
end