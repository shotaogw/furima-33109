class Item < ApplicationRecord
  validates :image, presence: true
  validates :title, presence: true
  validates :info,  presence: true
  with_options numericality: { other_than: 1, message: 'を選択してください' } do
    validates :category_id
    validates :status_id
    validates :shipping_fee_id
    validates :prefecture_id
    validates :delivery_day_id
  end
  validates :price, presence: true,
                    numericality: { with: /\A[0-9]+\z/, message: 'を半角数字で入力してください' }
  validates_inclusion_of :price, in: 300..9999999, message: 'を¥300~¥9999999の範囲で入力してください'

  belongs_to :user
  has_many :comments
  has_one_attached :image
  has_one :purchase

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :status
  belongs_to :shipping_fee
  belongs_to :prefecture
  belongs_to :delivery_day
end
