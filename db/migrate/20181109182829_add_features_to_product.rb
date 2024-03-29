class AddFeaturesToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :description, :text
    add_column :products, :price, :decimal, :precision => 8, :scale => 2
  end
end
