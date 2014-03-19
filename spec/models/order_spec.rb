require 'spec_helper'

describe Order do

  context 'test order state change' do
    before(:each) do
      @user = FactoryGirl.create(:user_recommended)
      @user_have_one_order = FactoryGirl.create(:user_have_one_order)
      @order = @user_have_one_order.orders.first
    end

    it 'order state should equal unpaid' do
      @order.state.should eq('unpaid')
      @order.get_state.should eq('未付款')
    end

    it 'order state should equal canceled' do
      @order.change_state_cancel
      @order.state.should eq('canceled')
      @order.get_state.should eq('已取消')
    end

    it 'order state should equal pending audit' do
      @order.change_state_pending_audit(100, 20)
      @order.state.should eq('pending_audit')
      @order.get_state.should eq('待审核')
    end

    it 'order state should equal wait ship' do
      Order.any_instance.should_receive(:generate_receiver_pdf)
      @order.change_state_pending_audit(100, 20)
      @order.change_state_wait_ship('dhl')
      @order.international_waybill_company.should eq('dhl')
      @order.state.should eq('wait_ship')
      @order.get_state.should eq('待发货')
    end

    it 'order state should equal completed' do
      Order.any_instance.should_receive(:generate_receiver_pdf)
      @order.change_state_pending_audit(100, 20)
      @order.change_state_wait_ship
      @order.change_state_completed('123')
      @order.international_waybill_no.should eq('123')
      @order.state.should eq('completed')
      @order.get_state.should eq('已完成')
    end


  end

  context 'change state to pending audit' do

    context 'with trade point' do
      before(:each) do
        @user = FactoryGirl.create(:user_recommended)
        @user_have_one_order = FactoryGirl.create(:user_have_one_order)
        @order = @user_have_one_order.orders.first
        @item = FactoryGirl.create(:item_with_order)
        @item.order = @order
        @item.save
        @order.change_state_pending_audit(100, 20)
      end

      it { @order.state.should == 'pending_audit' }

      it 'item state should change to pending audit' do
        item = Item.find(@item.id)
        item.state.should eq('pending_audit')
      end

      it { @order.total_price.should == 100 }

      it { User.find(@user_have_one_order.id).point.should == 1 }
    end

    context 'with not trade point' do
      before(:each) do
        @user = FactoryGirl.create(:user_recommended)
        @user_have_one_order = FactoryGirl.create(:user_have_one_order)
        @order = @user_have_one_order.orders.first
        @order.change_state_pending_audit(100, 0)
      end

      it { @order.state.should == 'pending_audit' }

      it { @order.total_price.should == 100 }

      it { User.find(@order.user.id).point.should == 21 }
    end

    context 'user have recommended' do

      it 'recommended complete first order' do
        user_recommended = FactoryGirl.create(:user_recommended)
        user_have_one_order = FactoryGirl.create(:user_have_one_order)
        order = user_have_one_order.orders.first
        order.change_state_pending_audit(100, 20)

        User.find(user_recommended.id).point.should == user_recommended.point + 20
      end

      it 'recommended complete other order' do
        user_recommended = FactoryGirl.create(:user_recommended)
        user_have_two_order = FactoryGirl.create(:user_have_two_order)
        order = user_have_two_order.orders.first
        order.change_state_pending_audit(100, 20)

        User.find(user_recommended.id).point.should == user_recommended.point
      end
    end

  end

  context 'is all items wait ship' do
    before(:each) do
      @order = FactoryGirl.create(:order)
      @item1 = FactoryGirl.create(:item_with_weight_1kg)
      @item1.state = :created_order
      @item1.order = @order
      @item1.save
      @item2 = FactoryGirl.create(:item_with_weight_1kg)
      @item2.state = :created_order
      @item2.order = @order
      @item2.save
    end

    it 'is all items wait ship' do
      @item1.state = 'wait_ship'
      @item1.save
      @item2.state = 'wait_ship'
      @item2.save
      @order.is_all_items_wait_ship.should eq(true)
    end

    it 'is not all items wait ship' do
      @order.is_all_items_wait_ship.should eq(false)
    end

  end

  context 'add share point' do
    before(:each) do
      @order = FactoryGirl.create(:order)
      @user_point = @order.user.point
    end

    context 'success' do
      it 'weixin' do
        @order.add_share_point('weixin')
        @order.is_share_weixin.should eq(true)
        @order.user.point.should eq(@user_point + 10)
      end

      it 'weibo' do
        @order.add_share_point('weibo')
        @order.is_share_weibo.should eq(true)
        @order.user.point.should eq(@user_point + 10)
      end
    end

  end

  it 'cal warehouse charges' do
    order = FactoryGirl.create(:order)
    item1 = FactoryGirl.create(:item_with_weight_1kg)
    item1.created_at = DateTime.now - 50
    item1.order = order
    item1.save
    item2 = FactoryGirl.create(:item_with_weight_1kg)
    item2.created_at = DateTime.now - 46
    item2.order = order
    item2.save
    order.cal_warehouse_charges.should eq(60)
  end

  it 'cal firm package charges' do
    order = FactoryGirl.create(:order)
    item1 = FactoryGirl.create(:item_with_weight_1kg)
    item1.order = order
    item1.save
    item2 = FactoryGirl.create(:item_with_weight_7kg)
    item2.order = order
    item2.save
    order.cal_firm_package_charges.should eq(20)
  end

end
