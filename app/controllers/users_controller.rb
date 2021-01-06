class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @items = @user.items.order(updated_at: :DESC)
    @purchases = @user.purchases.order(updated_at: :DESC)
  end
end
