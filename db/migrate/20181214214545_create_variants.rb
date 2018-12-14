class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.belongs_to :product, index: true
      t.belongs_to :size, index: true
      t.belongs_to :color, index: true
      t.decimal :price, precision: 8, scale: 2
      t.timestamps
    end
  end
end
