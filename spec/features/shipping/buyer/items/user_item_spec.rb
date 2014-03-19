require 'spec_helper'

describe 'user items', js: true do
  login_user
  before(:each) do
    visit '/shipping/buyer/items'
  end

  it 'should show correct' do
    page.should have_content '货品列表'
  end

  it 'should display error when not select item' do
    click_button '提交订单'
    expect(page).to have_content '至少选择一件货品'
  end

  it 'should redirect to order confirm' do
    item = FactoryGirl.create(:item)
    item.user = @user
    item.save
    visit '/shipping/buyer/items'
    check 'item_list_'
    click_button '提交订单'
    expect(page).to have_content '订单确认'
  end
end