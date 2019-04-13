class CreatePromos < ActiveRecord::Migration[5.2]
  def change
    create_table :promos do |t|
      t.string :owner_name
      t.string :code
      t.string :description
      t.decimal :discount_rate, precision: 8, scale: 2, null: false, default: 0
      t.timestamps
    end
    add_reference :orders, :promo, index: true, foreign_key: true unless column_exists?(:orders, :promo_id)
  end
end
