class City < ApplicationRecord
  belongs_to :country
  validates :name, :shipping_price, presence: true
  validates_uniqueness_of :name, scope: :country_id

  before_validation :set_shipping_price

  scope :egypt, -> { joins(:country).where(countries: {name: "Egypt"}) }


  def set_shipping_price
    if shipping_price.nil? || shipping_price.zero?
      self.shipping_price = country.default_shipping_price
    end
  end
end
