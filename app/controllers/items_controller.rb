class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_item, only: [:show, :edit, :update]
  before_action :move_to_index, only: :edit

  def index
    @items = Item.all.order(updated_at: :DESC)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.valid?
      @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :title, :info, :category_id, :status_id, :shipping_fee_id, :prefecture_id,
                                 :delivery_day_id, :price).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless current_user.id == @item.user_id
  end
end
