class Product < ApplicationRecord
  has_and_belongs_to_many :categories, -> { where(kind: :category) },:class_name => "Category", source: :categories
  has_and_belongs_to_many :sub_categories, -> { where(kind: :sub_category) },:class_name => "Category", source: :categories
  has_many :variants, inverse_of: :product, dependent: :destroy

  attr_accessor :color_ids

  has_attached_file :main_photo, styles: { medium: "300x300>", thumb: "100x100>" },
    :convert_options => {:medium => "-gravity center -extent 300x300"}
    
  validates_attachment_content_type :main_photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  
  after_create :create_variants_based_on_colors

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
    product_color_ids.each do |c|
      Size.all.each do |s|
        variants.create(color_id: c, size_id: s.id, price: price)
      end
    end
  end

  private
  def ransackable_attributes
    %w(name gender)
  end
  
end
