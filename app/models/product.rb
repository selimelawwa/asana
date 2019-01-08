class Product < ApplicationRecord
  has_and_belongs_to_many :categories, -> { where(kind: :category) },:class_name => "Category", source: :categories
  has_and_belongs_to_many :sub_categories, -> { where(kind: :sub_category) },:class_name => "Category", source: :categories
  has_many :variants, inverse_of: :product, dependent: :destroy


  attr_accessor :color_ids

  has_attached_file :main_photo, styles: { medium: "300x300>", thumb: "70x70>" },
    :convert_options => {:medium => "-gravity center -extent 300x300"}
    
  validates_attachment_content_type :main_photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  
  after_save :create_variants_based_on_colors

  # validations
  validates :name, :price, :category_ids, :sub_category_ids, :main_photo, presence: true
  validates :name, length: { minimum: 3, maximum: 60 }, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than: 0 }
  validate :sub_category_related_to_category

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

  def create_variants_based_on_colors
    product_color_ids = self.color_ids.reject { |c| c.empty? }
    if product_color_ids
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

  def available_in_stock_colors_ids
    c_ids = variants.main.pluck(:color_id)
    in_stock_c_ids = []
    c_ids.each do |c|
      if variants.sized.where("color_id = ? AND stock > 0",c).any?
        in_stock_c_ids << c
      end
    end
    in_stock_c_ids
  end

  def main_color_id
    available_in_stock_colors_ids.first
  end

  private
  def ransackable_attributes
    %w(name gender)
  end
  
end
