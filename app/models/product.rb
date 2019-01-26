class Product < ApplicationRecord
  has_and_belongs_to_many :categories, -> { where(kind: :category) },:class_name => "Category", source: :categories
  has_and_belongs_to_many :sub_categories, -> { where(kind: :sub_category) },:class_name => "Category", source: :categories
  has_many :variants, inverse_of: :product, dependent: :destroy
  has_and_belongs_to_many :tags

  scope :with_photos, -> { joins(variants: :variant_images).distinct } 
  scope :published, -> { where(published: true) }
  scope :hidden, -> { where(published: false) }

  attr_accessor :color_ids

  has_attached_file :main_photo, styles: { medium: "60%>", thumb: "70x70>" },
  convert_options: { :medium => "-quality 75" }

  validates_attachment_content_type :main_photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  after_save :create_variants_based_on_colors
  before_create :validate_color_ids_present
  before_save :set_stocks_to_zero_if_hidden
  before_validation :set_original_price

  # validations
  validates :name, :price, :original_price, :category_ids, :sub_category_ids, :main_photo, presence: true
  validates :name, length: { minimum: 3, maximum: 60 }, uniqueness: { case_sensitive: false }
  validates :price, :original_price, numericality: { greater_than: 0 }
  validate :sub_category_related_to_category
  validate :validate_price_less_than_original_price

  def sub_category_related_to_category
    if categories && sub_categories
      cat_ids = categories.map(&:id)
      sub_categories.each do |s|
        unless cat_ids.include? s.parent_id 
          errors.add(:sub_category_ids, "#{s.name} parent's category is not selected")
          throw :abort
        end
      end
    end
  end

  def validate_price_less_than_original_price
    if price > original_price
      errors.add(:price, "Price Must Be Less Than Original Price")
      throw :abort
    end
  end

  def validate_color_ids_present
    product_color_ids = self.color_ids.reject { |c| c.empty? }    
    unless product_color_ids.presence
      errors.add(:color_ids, "Please select at least 1 color")
      throw :abort
    end
  end
   
  def create_variants_based_on_colors
    product_color_ids = self.color_ids.reject { |c| c.empty? } if self.color_ids
    if product_color_ids.presence
      product_color_ids.each do |c|
        main = variants.where(color_id: c, kind: 'main', size_id: nil).first_or_create(price: price)
        Size.all.each do |s|
          v = variants.where(color_id: c, size_id: s.id, kind: 'sized', main_id: main.id).first_or_initialize
          v.price = price
          v.save
        end
      end
    end
  end

  def available_colors_ids
    variants.main.pluck(:color_id)
  end

  def available_colors
    Color.where(id: available_colors_ids)
  end

  def available_color_ids_with_images
    variants.main.joins(:variant_images).map(&:color_id)&.uniq
  end
  
  def available_colors_with_images
    Color.where(id: available_color_ids_with_images)
  end

  def available_in_stock_colors_ids
    c_ids = available_color_ids_with_images
    in_stock_c_ids = []
    c_ids.each do |c|
      if variants.sized.where("color_id = ? AND stock > 0",c).any?
        in_stock_c_ids << c
      end
    end
    in_stock_c_ids
  end

  def available_in_stock_colors_ids_without_images
    c_ids = available_colors_ids - available_color_ids_with_images
    in_stock_c_ids = []
    c_ids.each do |c|
      if variants.sized.where("color_id = ? AND stock > 0",c).any?
        in_stock_c_ids << c
      end
    end
    in_stock_c_ids
  end

  # variant with Image and stock
  def main_color_id
    available_in_stock_colors_ids.first || available_in_stock_colors_ids_without_images.first || available_colors_ids.first
  end

  #to be shown in index, get main_variant image or product main image
  def medium_photo
    variant_medium_photo(main_color_id)&.url(:medium) ||  main_photo.url(:medium)
  end

  def variant_medium_photo(color_id)
    variants.main.where(color_id: color_id).first&.main_photo&.image
  end

  #to be viewed with color select at product show
  def main_variant_image(color_id)
    variants.main.where(color_id: color_id).first.main_photo&.image || Color.find(color_id).photo
  end

  def set_stocks_to_zero_if_hidden
    if published_changed? && !published?
      variants.sized.each do |v|
        v.update(stock: 0)
      end
    end
  end

  def set_original_price
    self.original_price = price if (new_record? && original_price.nil?)
  end

  def out_of_stock?
    !variants.sized.where('stock > 0').any?
  end

  private
  def ransackable_attributes
    %w(name gender)
  end
  
end
