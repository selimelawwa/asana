class Category < ApplicationRecord
  enum kind: %i[category sub_category]

  has_and_belongs_to_many :products

  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category", optional: true
end
