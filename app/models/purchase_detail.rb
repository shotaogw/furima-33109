class PurchaseDetail

  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :address, :building, :phone_number, :user_id, :item_id, :token

  validates :postal_code,   presence: true, format: { with: /\A\d{3}[-]\d{4}\z/, message: 'input correctly' }
  validates :prefecture_id, numericality: { other_than: 1, message: 'select' }
  validates :city,          presence: true
  validates :address,       presence: true
  validates :phone_number,  presence: true, numericality: { with: /\d{,11}/, message: 'input only number' }
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :token,   presence: true

  def save
    purchase = Purchase.create(user_id: user_id, item_id: item_id)
    ShippingAddress.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, address: address, building: building, phone_number: phone_number, purchase_id: purchase.id)
  end

end