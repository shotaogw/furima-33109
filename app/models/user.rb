class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname,           presence: true
  validates :email,              uniqueness: true
  validates :password,
            format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze, message: 'を半角英数字混合で入力してください' }
  validates :password_confirmation, presence: true
  with_options presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々]+\z/, message: 'を全角(漢字・ひらがな・カタカナ)で入力してください' } do
    validates :first_name
    validates :last_name
  end
  with_options presence: true, format: { with: /\A[\p{katakana}\u{30fc}]+\z/, message: 'を全角(カタカナ)で入力してください' } do
    validates :first_name_kana
    validates :last_name_kana
  end
  validates :date_of_birth, presence: true

  has_many :items
  has_many :comments
  has_many :purchases
end
