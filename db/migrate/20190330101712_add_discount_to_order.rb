class AddDiscountToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :discount, :decimal, precision: 8, scale: 2, null: false, default: 0
  end
end
