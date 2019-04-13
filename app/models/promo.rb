class Promo < ApplicationRecord
  validates :code, :discount_rate, presence: true
  validates :discount_rate, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :code, length: { minimum: 5, maximum: 60 }, uniqueness: { case_sensitive: false }
  validates :code, format: { without: /\s/, message: "must contain no spaces" }

  scope :active_promos, -> { where(active: true) }

end
