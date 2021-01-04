class Item < ApplicationRecord
  validates :image, presence: true
  validates :title, presence: true
  validates :info,  presence: true
  with_options numericality: { other_than: 1, message: 'select' } do
    validates :category_id
    validates :status_id
    validates :shipping_fee_id
    validates :prefecture_id
    validates :delivery_day_id
  end
  validates :price, presence: true,
                    numericality: { with: /\A[0-9]+\z/, message: 'half-width number' }
  validates_inclusion_of :price, in: 300..9_999_999, message: 'out of setting range'

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
