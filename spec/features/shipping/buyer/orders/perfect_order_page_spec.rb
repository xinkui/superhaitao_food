require 'spec_helper'

describe 'open perfect order page', js: true do
  login_user

  before(:each) do
    @order = FactoryGirl.create(:order)
    @item1 = FactoryGirl.create(:item_with_weight_1kg)
    @item1.created_at = DateTime.now - 50
    @item1.order = @order
    @item1.save
    @item2 = FactoryGirl.create(:item_with_weight_7kg)
    @item2.created_at = DateTime.now - 46
    @item2.order = @order
    @item2.save
    @order.user = @user
    @order.save
    FactoryGirl.create(:price_weight_8kg)
  end

  context 'init' do

    it 'have warehouse charges' do
      visit '/shipping/buyer/orders/confirm?id=' + @order.id.to_s
      find('#lbl_total_price').should have_content '160.0'
    end

    it 'have not warehouse charges' do
      @item1.created_at = DateTime.now
      @item1.save
      @item2.created_at = DateTime.now
      @item2.save
      visit '/shipping/buyer/orders/confirm?id=' + @order.id.to_s
      find('#lbl_total_price').should have_content '100.0'
    end

  end

  it 'checked firm package' do
    visit '/shipping/buyer/orders/confirm?id=' + @order.id.to_s
    check('chk_firm_package')
    find('#lbl_total_price').should have_content '180.0'
    uncheck('chk_firm_package')
    find('#lbl_total_price').should have_content '160.0'
  end

  it 'change balloon' do
    visit '/shipping/buyer/orders/confirm?id=' + @order.id.to_s
    fill_in('txt_balloon', :with => '2')
    find('#lbl_total_price').should have_content '170.0'
  end

end