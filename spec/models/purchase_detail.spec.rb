require 'rails_helper'

RSpec.describe PurchaseDetail, type: :model do
  before do
    @test = FactoryBot.build(:purchase_detail)
  end

  describe '商品購入' do
    context '商品購入ができるとき' do
      it '必要な情報を適切に入力すると商品の購入ができること' do
        expect(@test).to be_valid
      end
      it 'buildingが空でも購入できる' do
        @test.building = nil
        expect(@test).to be_valid
      end
    end

    context '商品購入ができないとき' do
      it 'postal_codeが空では購入できない' do
        @test.postal_code = nil
        @test.valid?
        expect(@test.errors.full_messages).to include("Postal code can't be blank")
      end
      it 'postal_codeが半角のハイフンを含んだ正しい形式でないと購入できない' do
        @test.postal_code = "１２３-４５６７"
        @test.valid?
        expect(@test.errors.full_messages).to include("Postal code input correctly")
      end
      it 'prefecture_idが1であると購入できない' do
        @test.prefecture_id = 1
        @test.valid?
        expect(@test.errors.full_messages).to include("Prefecture select")
      end
      it 'cityが空では購入できない' do
        @test.city = nil
        @test.valid?
        expect(@test.errors.full_messages).to include("City can't be blank")
      end
      it 'addressが空では購入できない' do
        @test.address = nil
        @test.valid?
        expect(@test.errors.full_messages).to include("Address can't be blank")
      end
      it 'phone_numberが空では購入できない' do
        @test.phone_number = nil
        @test.valid?
        expect(@test.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが半角のハイフンを含まない11桁以内で正しい形式でないと購入できない' do
        @test.phone_number = "090-1234-5678"
        @test.valid?
        expect(@test.errors.full_messages).to include("Phone number input only number")
      end
      it 'user_idが空では購入できない' do
        @test.user_id = nil
        @test.valid?
        expect(@test.errors.full_messages).to include("User can't be blank")
      end
      it 'item_idが空では購入できない' do
        @test.item_id = nil
        @test.valid?
        expect(@test.errors.full_messages).to include("Item can't be blank")
      end
    end

  end
end