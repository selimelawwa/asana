class Order < ApplicationRecord
  has_many :line_items, -> { order(:created_at) }, inverse_of: :order, dependent: :destroy
  has_many :variants, through: :line_items
  has_many :products, through: :variants
  belongs_to :user

  enum status: %i[in_cart address confirmed delivered canceled]
  
  scope :cart, -> { where(cart: true) }
  scope :completed, -> { where(cart: false) }
end
