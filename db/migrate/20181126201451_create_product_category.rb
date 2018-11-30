class CreateProductCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_products, id: false do |t|
      t.belongs_to :product, index: true
      t.belongs_to :category, index: true
    end
    add_column :categories, :kind, :int
    add_reference :categories, :parent, index: true
  end
end