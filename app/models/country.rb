class Country < ApplicationRecord
  has_many :cities, dependent: :destroy
  
  validates :name, :default_shipping_price, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :default_shipping_price, numericality: { greater_than: 0 }

end
