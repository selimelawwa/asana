class CreateVariantImages < ActiveRecord::Migration[5.2]
  def change
    create_table :variant_images do |t|
      t.belongs_to :variant, index: true
      t.belongs_to :image, index: true
      t.timestamps
    end
  end
end
