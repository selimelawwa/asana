class Variant < ApplicationRecord
  belongs_to :product, inverse_of: :variants
  belongs_to :size
  belongs_to :color
  has_many :variant_images
  has_many :images, through: :variant_images

  validates_uniqueness_of :product_id, scope: [:color_id, :size_id]
end
