require 'spec_helper'

describe Shipping::Admin::OrdersController do

  login_admin

  let(:valid_session) { {} }

  context 'add share point' do
    before(:each) do
      @order = FactoryGirl.create(:order)
    end

    it 'success' do
      get :add_share_point, { id: @order.id, share: :weibo }, valid_session
      flash[:notice].should eq('积分增加成功!')
      order = Order.find(@order.id)
      order.is_share_weibo.should eq(true)
      order.user.point.should eq(@order.user.point + 10)
      respond_to.should redirect_to(action: :index)
    end

    it 'fail' do
      Order.any_instance.should_receive(:save!).and_raise(Exception.new)
      get :add_share_point, { id: @order.id, share: :weibo }, valid_session
      order = Order.find(@order.id)
      order.user.point.should eq(@order.user.point)
      order.is_share_weibo.should eq(false)
      flash[:alert].should eq('积分增加失败,请重新操作!')
      respond_to.should redirect_to(action: :index)
    end
  end

  context 'change state to wait ship' do
    before(:each) do
      @user = FactoryGirl.create(:user_recommended)
      @user_have_one_order = FactoryGirl.create(:user_have_one_order)
      @order = @user_have_one_order.orders.first
      @item = FactoryGirl.create(:item_with_order)
      @item.order = @order
      @item.save
      @order.change_state_pending_audit(100, 20)
    end

    it 'all items state is wait ship' do
      @item.state = 'wait_ship'
      @item.save
      Order.any_instance.should_receive(:generate_receiver_pdf)
      post :checked_order, { order: { id: @order.id } }, valid_session
      flash[:notice].should eq('订单审核完成!')
      response.should redirect_to(action: :index)
    end

    it 'all items state is not wait ship' do
      post :checked_order, { order: { id: @order.id } }, valid_session
      flash[:alert].should eq('还有货品未审核，请先审核货品!')
      response.should redirect_to(action: :show_checked_order, id: @order.id)
    end

  end

end