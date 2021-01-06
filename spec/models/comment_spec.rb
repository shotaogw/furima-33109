require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe '商品へのコメント' do
    it '必要な情報を適切に入力するとコメントができる' do
      expect(@comment).to be_valid
    end
    it 'comment_textが空ではコメントできない' do
      @comment.comment_text = nil
      @comment.valid?
      expect(@comment.errors.full_messages).to include('コメントを入力してください')
    end
    it 'userが紐づいていないとコメントできない' do
      @comment.user = nil
      @comment.valid?
      expect(@comment.errors.full_messages).to include('ユーザーを入力してください')
    end
    it 'itemが紐づいていないとコメントできない' do
      @comment.item = nil
      @comment.valid?
      expect(@comment.errors.full_messages).to include('商品を入力してください')
    end
  end
end
