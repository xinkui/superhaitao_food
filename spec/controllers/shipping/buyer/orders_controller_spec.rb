require 'spec_helper'

describe Shipping::Buyer::OrdersController do

  login_user

  let(:valid_session) { {} }

  before(:each) do
    @price = FactoryGirl.create(:price_weight_2kg)
    @item1 = FactoryGirl.create(:item_with_weight_1kg)
    @item2 = FactoryGirl.create(:item_with_weight_1kg_other_sku)
    @order = FactoryGirl.create(:order)
    @item1.user = @user
    @item1.order = @order
    @item1.save
    @item2.user = @user
    @item2.order = @order
    @item2.save
    @order.user = @user
    @order.save
  end

  context 'payment' do

    context 'payment with point' do

      it 'trade point equal and larger then total price' do
        @user.point = @price.price + 100
        @user.save
        post :payment, { order: { id: @order.id }, trade_point: @price.price + 10 }, valid_session
        assigns(:status).should eq('payment success')
        response.should render_template('orders/complete_payment')
      end

      context 'trade point smaller then total price' do
        before(:each) do
          receiver = FactoryGirl.create(:receiver)
          @order.receiver_message = receiver.show_receiver_message
          @order.receiver = receiver
          @order.save
        end


        it 'call alipay success' do
          trade_point = @price.price - 80
          @user.point = trade_point
          @user.save
          post :payment, {order: {id: @order.id}, trade_point: trade_point}, valid_session
          Order.find(@order.id).trade_point.should == trade_point
          options = {
              out_trade_no: @order.number + '_' + @user.id.to_s + '_S',
              subject: @order.number,
              logistics_type: 'EXPRESS',
              logistics_fee: '0',
              logistics_payment: 'SELLER_PAY',
              price: @price.price - trade_point,
              quantity: 1,
              discount: 0,
              return_url: 'http://localhost:3000/shipping/buyer/orders/complete_payment_from_alipay',
              notify_url: 'http://192.241.180.75:3000/shipping/buyer/orders/notify_url_from_alipay',
              receive_name: @order.receiver.name,
              receive_address: @order.receiver.address,
              receive_zip: @order.receiver.zip_code,
              receive_phone: @order.receiver.phone
          }

          response.should redirect_to(Alipay::Service.create_partner_trade_by_buyer_url(options))
        end

        it 'call alipay fail' do
          trade_point = @price.price - 80
          @user.point = trade_point
          @user.save
          Alipay::Service.should_receive(:create_partner_trade_by_buyer_url).and_raise(Exception.new)
          post :payment, {order: {id: @order.id}, trade_point: trade_point}, valid_session
          flash[:alert].should eq('支付失败，请重新操作')
          response.should redirect_to(action: :open_payment_page, id: @order.id)
        end
      end

      it 'throw exception' do
        Order.any_instance.should_receive(:change_state_pending_audit).and_raise(Exception.new)
        post :payment, { order: { id: @order.id }, trade_point: @price.price + 10 }, valid_session
        response.should redirect_to(action: :open_payment_page, id: @order.id)
      end

    end

    context 'complete payment' do
      let(:out_trade_no) { @order.number + '_' + @user.id.to_s }
      let(:trade_no) { '123' }
      let(:gmt_create) { DateTime.now }
      let(:gmt_payment) { DateTime.now }

      context 'success' do
        it 'save success' do
          post :complete_payment_from_alipay, { out_trade_no: out_trade_no, is_success: 'T', trade_no: trade_no,
                                                trade_status: 'WAIT_SELLER_SEND_GOODS', gmt_create: gmt_create,
                                                gmt_payment: gmt_payment }, valid_session
          assigns(:status).should eq('payment success')
          order = Order.find(@order.id)
          order.trade_no.should eq(trade_no)
          order.gmt_create.to_i.should eq(gmt_create.to_i)
          order.gmt_payment.to_i.should eq(gmt_payment.to_i)
          response.should render_template('orders/complete_payment')
        end

        it 'save fail' do
          Order.any_instance.should_receive(:change_state_pending_audit).and_raise(Exception.new)
          post :complete_payment_from_alipay, { out_trade_no: out_trade_no, is_success: 'T',
                                                trade_status: 'WAIT_SELLER_SEND_GOODS', trade_no: trade_no,
                                                gmt_create: gmt_create, gmt_payment: gmt_payment }, valid_session
          assigns(:status).should eq('save failed')
          response.should render_template('orders/complete_payment')
        end
      end

      it 'fail' do
        post :complete_payment_from_alipay, { out_trade_no: out_trade_no, is_success: 'F' }, valid_session
        assigns(:status).should eq('payment failed')
        response.should render_template('orders/complete_payment')
      end

    end

  end

  context 'notify url from alipay' do
    let(:out_trade_no) { @order.number + '_' + @user.id.to_s }
    let(:trade_no) { '123' }
    let(:gmt_create) { DateTime.now }
    let(:gmt_payment) { DateTime.now }

    context 'success' do
      context 'alipay return url fail' do
        it 'save success' do
          @order.trade_no.should eq(nil)
          Alipay::Notify.should_receive(:verify?).and_return(true)
          post :notify_url_from_alipay, { out_trade_no: out_trade_no, trade_status: 'WAIT_SELLER_SEND_GOODS', trade_no: trade_no,
                                          gmt_create: gmt_create, gmt_payment: gmt_payment }, valid_session
          response.body.should eq('success')
        end
        it 'save fail' do
          @order.trade_no.should eq(nil)
          Alipay::Notify.should_receive(:verify?).and_return(true)
          Order.any_instance.should_receive(:change_state_pending_audit).and_raise(Exception.new)
          post :notify_url_from_alipay, { out_trade_no: out_trade_no, trade_status: 'WAIT_SELLER_SEND_GOODS',
                                          trade_no: trade_no, gmt_create: gmt_create,
                                          gmt_payment: gmt_payment }, valid_session
          response.body.should eq('fail')
        end
      end

      it 'alipay return url success' do
        @order.trade_no = trade_no
        @order.save
        Alipay::Notify.should_receive(:verify?).and_return(true)
        post :notify_url_from_alipay, { out_trade_no: out_trade_no, trade_status: 'WAIT_SELLER_SEND_GOODS', trade_no: trade_no,
                                        gmt_create: gmt_create, gmt_payment: gmt_payment }, valid_session
        response.body.should eq('success')
      end
    end

    it 'fail' do
      Alipay::Notify.should_receive(:verify?).and_return(false)
      post :notify_url_from_alipay, { out_trade_no: out_trade_no, is_success: 'T', trade_no: trade_no,
                                      gmt_create: gmt_create, gmt_payment: gmt_payment }, valid_session
      response.body.should eq('fail')
    end
  end

end
