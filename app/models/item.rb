class Item < ApplicationRecord 
  validates :image, presence: true
  validates :title, presence: true
  validates :info,  presence: true
  validates :category_id,     numericality: { other_than: 1, message: 'select' }
  validates :status_id,       numericality: { other_than: 1, message: 'select' }
  validates :shipping_fee_id, numericality: { other_than: 1, message: 'select' }
  validates :prefecture_id,   numericality: { other_than: 1, message: 'select' }
  validates :delivery_day_id, numericality: { other_than: 1, message: 'select' }
  validates :price, presence: true,
    format: { with: /\A[0-9]+\z/, message: 'half-width number' },
    numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999 }

  belongs_to :user
  has_one_attached :image

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :status
  belongs_to :shipping_fee
  belongs_to :prefecture
  belongs_to :delivery_day
end