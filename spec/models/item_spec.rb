require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品' do
    context '商品出品ができるとき' do
      it '必要な情報を適切に入力すると商品出品ができる' do
        expect(@item).to be_valid
      end
    end

    context '商品出品ができないとき' do
      it 'imageが空では出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image can't be blank")
      end
      it 'titleが空では出品できない' do
        @item.title = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Title can't be blank")
      end
      it 'infoが空では出品できない' do
        @item.info = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Info can't be blank")
      end
      it 'category_idの情報がないと出品できない' do
        @item.category_id = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Category select')
      end
      it 'status_idの情報がないと出品できない' do
        @item.status_id = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Status select')
      end
      it 'shipping_fee_idの情報がないと出品できない' do
        @item.shipping_fee_id = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping fee select')
      end
      it 'prefecture_idの情報がないと出品できない' do
        @item.prefecture_id = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Prefecture select')
      end
      it 'delivery_day_idの情報がないと出品できない' do
        @item.delivery_day_id = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Delivery day select')
      end
      it 'priceが空では出品できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Price can't be blank")
      end
      it 'priceが¥300~¥9,999,999以外の値である場合出品できない' do
        @item.price = '200'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price out of setting range')
      end
      it 'priceが半角数字でないと出品できない' do
        @item.price = '３００'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price half-width number', 'Price out of setting range')
      end
      it 'userが紐づいていないと出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('User must exist')
      end
    end
  end
end
