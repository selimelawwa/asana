class RemoveProductExtraPhotoAddVariantStock < ActiveRecord::Migration[5.2]
  def change
    remove_attachment :products, :products
    add_column :variants, :stock, :integer
  end
end
