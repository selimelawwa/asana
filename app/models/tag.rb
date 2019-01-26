class Tag < ApplicationRecord
  has_and_belongs_to_many :products

  with_options presence: true,length: { minimum: 3 }, uniqueness: { case_sensitive: false } do
    validates :name
  end
  # TODO add where product published
  scope :with_products, -> { joins(:products).distinct } 
end
