class AddIndexOnProductColorSizeIdsAtVariant < ActiveRecord::Migration[5.2]
  def change
    add_index :variants, [:product_id, :color_id , :size_id], unique: true
  end
end
