class Order < ApplicationRecord
  has_many :line_items, -> { order(:created_at) }, inverse_of: :order
  has_many :variants, through: :line_items
  has_many :products, through: :variants
  belongs_to :user
end
