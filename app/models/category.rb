class Category < ApplicationRecord
  enum kind: %i[category sub_category]

  has_and_belongs_to_many :products

  has_many :sub_categories, -> { where kind: 'sub_category' }, :class_name => "Category", :dependent => :destroy, :foreign_key => "parent_id"
  belongs_to :parent_category, -> { where kind: 'category' }, :class_name => "Category", optional: true, :foreign_key => "parent_id"
end
