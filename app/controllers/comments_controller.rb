class CommentsController < ApplicationController
  before_action :set_comment_item

  def index
    @comment = Comment.new
    @comments = @item.comments.includes(:user).order(created_at: :DESC)
  end

  def create
    @comment = @item.comments.new(comment_params)
    if @comment.save
      redirect_to item_comments_path(@item.id)
    else
      @comments = @item.comments.includes(:user)
      render :index
    end
  end

  private

  def set_comment_item
    @item = Item.find(params[:item_id])
  end

  def comment_params
    params.require(:comment).permit(:comment_text).merge(user_id: current_user.id, item_id: params[:item_id])
  end

end
