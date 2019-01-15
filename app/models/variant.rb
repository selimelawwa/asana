class Variant < ApplicationRecord
  #main variants, are variants with color but no size assigned
  enum kind: %i[main sized]
  belongs_to :product, inverse_of: :variants
  belongs_to :size, optional: true
  belongs_to :color
  has_many :variant_images, dependent: :destroy
  has_many :images, through: :variant_images

  has_many :line_items, -> { order(:created_at) }, inverse_of: :variant
  has_many :orders, through: :line_items

  has_many :sized_variants, -> { where kind: 'sized' }, :class_name => "Variant", :dependent => :destroy, :foreign_key => "main_id"
  belongs_to :main_variant, -> { where kind: 'main' }, :class_name => "Variant", optional: true, :foreign_key => "main_id"

  validates :size, presence: true, if: -> { sized? }
  validates :main_variant, presence: true, if: -> { sized? }
  validates_uniqueness_of :product_id, scope: [:color_id, :size_id]

  def photos
    if sized?
      main_variant.images
    else
      images
    end
  end

  def main_photo
    photos.first
  end

  def name_with_options_text
    "#{product.name} - #{options_text}"
  end

  def options_text
    "#{color.name} - #{size&.name}"
  end
  def color_text
    "#{color.name}"
  end

end
