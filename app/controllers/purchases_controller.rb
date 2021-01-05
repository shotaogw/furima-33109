class PurchasesController < ApplicationController
  before_action :set_item, only: [:index, :create]
  before_action :authenticate_user!

  def index
    @purchase_detail = PurchaseDetail.new
  end

  def create
    @purchase_detail = PurchaseDetail.new(purchase_params)
    if @purchase_detail.valid?
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      Payjp::Charge.create(
        amount: @item.price,
        card: purchase_params[:token],
        currency: 'jpy'
      )
      @purchase_detail.save
      redirect_to items_path
    else
      render action: :index
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def purchase_params
    params.require(:purchase_detail).permit(:postal_code, :prefecture_id, :city, :address, :building, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

end