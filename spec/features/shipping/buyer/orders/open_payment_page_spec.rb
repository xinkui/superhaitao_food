require 'spec_helper'

describe 'open payment page', js: true do
  login_user
  before(:each) do
    item = FactoryGirl.create(:item_with_order)
    item.user = @user
    item.save
    @order = item.order
    @order.user = @user
    @order.save
    FactoryGirl.create(:price_weight_2kg)
  end

  context 'init' do

    context 'init user point smaller than total price' do
      before(:each) do
        @user.point = 20
        visit '/shipping/buyer/orders/open_payment_page?id=' + @order.id.to_s
      end

      it { find('#total_price').should have_content '100.0' }

      it { find('#user_point').should have_content '20.0' }

      it { find('#alipay_price').should have_content '100.0' }

      it { find('#chk_point').should_not be_checked }

      it { find('#trade_point').should be_disabled }
    end

    context 'init user point larger than total price' do
      before(:each) do
        @user.point = 200.02
        visit '/shipping/buyer/orders/open_payment_page?id=' + @order.id.to_s
      end

      it { find('#total_price').should have_content '100.0' }

      it { find('#user_point').should have_content '200.02' }

      it { find('#alipay_price').should have_content '100.0'}

      it { find('#chk_point').should_not be_checked }

      it { find('#trade_point').should be_disabled }
    end

    context 'init user point equal total price' do
      before(:each) do
        @user.point = 100
        visit '/shipping/buyer/orders/open_payment_page?id=' + @order.id.to_s
      end

      it { find('#total_price').should have_content '100.0' }

      it { find('#user_point').should have_content '100.0' }

      it { find('#alipay_price').should have_content '100.0' }

      it { find('#chk_point').should_not be_checked }

      it { find('#trade_point').should be_disabled }
    end

    context 'init user point equal 0' do
      before(:each) do
        @user.point = 0
        visit '/shipping/buyer/orders/open_payment_page?id=' + @order.id.to_s
      end

      it { find('#total_price').should have_content '100.0' }

      it { find('#user_point').should have_content '0.0' }

      it { find('#alipay_price').should have_content '100.0' }

      it { find('#chk_point').should be_disabled }

      it { find('#trade_point').should be_disabled }
    end
  end

  context 'check chk point' do
    before(:each) do
      @user.point = 20
      visit '/shipping/buyer/orders/open_payment_page?id=' + @order.id.to_s
    end

    context 'checked chk point' do
      before(:each) do
        check('chk_point')
      end

      it { find('#trade_point').should_not be_disabled }

      context 'trade point larger then user point' do
        before(:each) do
          fill_in('trade_point', :with => '30')
        end

        it { page.should have_content '数值超过可用积分' }

        it { find('#div_trade_point')[:class].should have_content 'has-error' }

        it { find('#btn_submit').should be_disabled }
      end

      context 'trade point smaller equal then user point' do
        before(:each) do
          fill_in('trade_point', :with => '20')
        end

        it { page.should_not have_content '数值超过可用积分' }

        it { find('#div_trade_point')[:class].should_not have_content 'has-error'}

        it { find('#btn_submit').should_not be_disabled }
      end

    end

    context 'unchecked chk point' do
      before(:each) do
        uncheck('chk_point')
      end

      it { find('#trade_point').should be_disabled }

      it { find('#alipay_price').should have_content 100 }

      context 'trade point fill in wrong number' do
        before(:each) do
          check('chk_point')
          fill_in('trade_point', :with => '3.')
          uncheck('chk_point')
        end
        it { page.should_not have_content '请输入正确格式' }
        it { find('#div_trade_point')[:class].should_not have_content 'has-error'}
        it { find('#btn_submit').should_not be_disabled }
      end

      context 'trade point larger then user point btn submit should not be disabled' do
        before(:each) do
          check('chk_point')
          fill_in('trade_point', :with => '30')
          uncheck('chk_point')
        end
        it { page.should_not have_content '数值超过可用积分' }
        it { find('#div_trade_point')[:class].should_not have_content 'has-error'}
        it { find('#btn_submit').should_not be_disabled }
      end

      it 'trade point smaller then user point btn submit should not be disabled' do
        check('chk_point')
        fill_in('trade_point', :with => '10')
        uncheck('chk_point')
        find('#btn_submit').should_not be_disabled
      end
    end
  end

  context 'trade point property change' do
    before(:each) do
      @user.point = 20
      visit '/shipping/buyer/orders/open_payment_page?id=' + @order.id.to_s
    end

    context 'trade point fill in number' do
      before(:each) do
        check('chk_point')
        fill_in('trade_point', :with => '3')
      end

      it { page.should_not have_content '请输入正确格式' }

      it { find('#div_trade_point')[:class].should_not have_content 'has-error'}

      it { find('#btn_submit').should_not be_disabled }
    end

    context 'trade point fill in smaller then user point and larger then total price' do
      before(:each) do
        @user.point = 200
        check('chk_point')
        fill_in('trade_point', :with => '120')
      end

      it { page.should have_content '本次最多可用积分为' }

      it { find('#div_trade_point')[:class].should have_content 'has-error'}

      it { find('#btn_submit').should be_disabled }
    end

    context 'trade point fill in wrong number' do
      before(:each) do
        check('chk_point')
        fill_in('trade_point', :with => '3.')
      end

      it { page.should have_content '请输入正确格式' }

      it { find('#div_trade_point')[:class].should have_content 'has-error'}

      it { find('#btn_submit').should be_disabled }
    end

    context 'fill larger then user point and wrong number in trade point' do
      before(:each) do
        check('chk_point')
        fill_in('trade_point', :with => '31')
      end

      context 'trade point fill in larger then user point' do

        it { page.should have_content '数值超过可用积分' }

        it { find('#div_trade_point')[:class].should have_content 'has-error'}

        it { find('#btn_submit').should be_disabled }

        context 'trade point fill in wrong number' do
          before(:each) do
            fill_in('trade_point', :with => '31.')
          end

          it { page.should_not have_content '数值超过可用积分' }

          it { page.should have_content '请输入正确格式' }

          it { find('#div_trade_point')[:class].should have_content 'has-error'}

          it { find('#btn_submit').should be_disabled }
        end

      end

    end

    it 'alipay price should be change' do
      check('chk_point')
      fill_in('trade_point', :with => '20')
      find('#alipay_price').should have_content '80'
      fill_in('trade_point', :with => '200')
      find('#alipay_price').should have_content '80'
      fill_in('trade_point', :with => '0')
      find('#alipay_price').should have_content '100'
    end

  end

end