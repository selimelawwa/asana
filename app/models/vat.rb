class Vat < ApplicationRecord

  validates :tax_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def self.default
    self.where(name: 'default').first_or_create
  end
  def tax_rate_percentage
    tax_rate.to_f/100
  end
end
