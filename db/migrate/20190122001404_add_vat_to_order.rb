class AddVatToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :vat, :decimal, precision: 8, scale: 2, null: false, default: 0
  end
end
