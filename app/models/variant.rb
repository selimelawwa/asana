class Variant < ApplicationRecord
  belongs_to :product, inverse_of: :variants
  belongs_to :size
  belongs_to :color
end
