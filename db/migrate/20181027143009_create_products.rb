class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :barcode
      t.string :gender
      t.attachment :products, :main_photo
      t.timestamps
    end
  end
end
