class CommentsController < ApplicationController
  before_action :set_comment_item
  before_action :authenticate_user!

  def index
    @comment = Comment.new
    @comments = @item.comments.includes(:user).order(created_at: :DESC)
  end

  def create
    @comment = @item.comments.new(comment_params)
    if @comment.valid?
      @comment.save
      redirect_to item_comments_path(@item.id)
    else
      @comments = @item.comments.includes(:user).order(created_at: :DESC)
      render :index
    end
  end

  def destroy
    comment = @item.comments.find(params[:id])
    comment.destroy
    redirect_to item_comments_path(@item.id)
  end

  private

  def set_comment_item
    @item = Item.find(params[:item_id])
  end

  def comment_params
    params.require(:comment).permit(:comment_text).merge(user_id: current_user.id, item_id: params[:item_id])
  end

end
