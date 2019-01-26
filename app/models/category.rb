class Category < ApplicationRecord
  enum kind: %i[category sub_category]

  has_and_belongs_to_many :products

  has_many :sub_categories, -> { where kind: 'sub_category' }, :class_name => "Category", :dependent => :destroy, :foreign_key => "parent_id"
  belongs_to :parent_category, -> { where kind: 'category' }, :class_name => "Category", optional: true, :foreign_key => "parent_id"

  # TODO add where product published
  scope :with_products, -> { joins(:products).distinct }

  # validations
  validates :name, :kind, presence: true
  validates :parent_category, presence: true, if: -> { sub_category? }
  validates :name, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false }, if: -> { category? }
  validates :name, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false, scope: :parent_category }, if: -> { sub_category? }
end
