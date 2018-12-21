class Variant < ApplicationRecord
  belongs_to :product, inverse_of: :variants
  belongs_to :size
  belongs_to :color
  has_many :variant_images
  has_many :images, through: :variant_images
end
