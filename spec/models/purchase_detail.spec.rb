require 'rails_helper'

RSpec.describe PurchaseDetail, type: :model do
  before do
    @purchaser = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @purchase_detail = FactoryBot.build(:purchase_detail, user_id: @purchaser.id, item_id: @item.id)
    sleep 0.1
  end

  describe '商品購入' do
    context '商品購入ができるとき' do
      it '必要な情報を適切に入力すると商品の購入ができること' do
        expect(@purchase_detail).to be_valid
      end
      it 'buildingが空でも購入できる' do
        @purchase_detail.building = nil
        expect(@purchase_detail).to be_valid
      end
    end

    context '商品購入ができないとき' do
      it 'postal_codeが空では購入できない' do
        @purchase_detail.postal_code = nil
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include("Postal code can't be blank")
      end
      it 'postal_codeが半角のハイフンを含んだ正しい形式でないと購入できない' do
        @purchase_detail.postal_code = '１２３-４５６７'
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include('Postal code input correctly')
      end
      it 'prefecture_idが1であると購入できない' do
        @purchase_detail.prefecture_id = 1
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include('Prefecture select')
      end
      it 'cityが空では購入できない' do
        @purchase_detail.city = nil
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include("City can't be blank")
      end
      it 'addressが空では購入できない' do
        @purchase_detail.address = nil
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include("Address can't be blank")
      end
      it 'phone_numberが空では購入できない' do
        @purchase_detail.phone_number = nil
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが半角のハイフンを含まない11桁以内で正しい形式でないと購入できない' do
        @purchase_detail.phone_number = '090-1234-5678'
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include('Phone number input only number')
      end
      it 'user_idが空では購入できない' do
        @purchase_detail.user_id = nil
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include("User can't be blank")
      end
      it 'item_idが空では購入できない' do
        @purchase_detail.item_id = nil
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include("Item can't be blank")
      end
      it 'tokenが空では購入できない' do
        @purchase_detail.token = nil
        @purchase_detail.valid?
        expect(@purchase_detail.errors.full_messages).to include("Token can't be blank")
      end
    end
  end
end
