class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.references :order, index: true, foreign_key: true
      t.references :variant, index: true, foreign_key: true
      t.integer :quantity
      t.decimal :cost
      t.timestamps
    end
  end
end
