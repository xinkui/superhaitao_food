require 'spec_helper'

describe 'Login' do
  login_user
  context "home page", js: :true do
    before(:each) do
      visit root_path
    end

    it "should have index url" do
      page.should have_link('首页')
    end

    it "should have order url" do
      page.should have_link('我的订单')
    end

  end

  context "login" do
    before(:each) do
      visit '/users/sign_in'
    end

    it "login admin correct" , js: :true do
      FactoryGirl.create(:admin)
      fill_in 'user_name', with: 'admin'
      fill_in 'user_password', with: 'admin888'
      click_button '登陆'
      expect(page).to have_content '货品管理'
    end

    it "login user correct" do
      FactoryGirl.create(:user)
      fill_in 'user_name', with: 'getdown'
      fill_in 'user_password', with: '12345678'
      click_button '登陆'
      expect(page).to have_content '我的账户'
    end
  end

end