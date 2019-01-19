class Country < ApplicationRecord
  has_many :cities, dependent: :destroy
  
  validates :name, :default_shipping_price, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :default_shipping_price, numericality: { greater_than: 0 }

  def self.named_egypt
    egypt = find_or_initialize_by(name: 'Egypt')
    if egypt.new_record?
      egypt.default_shipping_price  = 50
      egypt.save
    end
    egypt
  end

end
