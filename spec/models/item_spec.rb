require 'spec_helper'

describe Item do

  context 'count new items by user' do
    it 'have user' do
      user = FactoryGirl.create(:user)
      item1 = FactoryGirl.create(:item)
      item1.user = user
      item1.save
      item2 = FactoryGirl.create(:item_with_weight_1kg)
      item2.user = user
      item2.state = :completed
      item2.save
      Item.count_new_items_by_user(user).should eq(1)
    end

    it 'user is nil' do
      Item.count_new_items_by_user(nil).should eq(0)
    end
  end

  it 'should not be deleted when belongs to order' do
    item = FactoryGirl.create(:item_with_order)
    expect {item.destroy}.to_not change(Item, :count)
    item.errors.messages[:base].should include '已经有关联订单，不能删除!'
  end

  it 'can be deleted when order is null' do
    item = FactoryGirl.create(:item)
    expect {item.destroy}.to change(Item, :count)
  end

end
