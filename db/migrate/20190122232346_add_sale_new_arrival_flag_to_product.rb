class AddSaleNewArrivalFlagToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :original_price, :decimal, :precision => 8, :scale => 2
    add_column :products, :on_sale, :boolean, default: false unless column_exists?(:products, :on_sale)
    add_column :products, :new_arrival, :boolean, default: false unless column_exists?(:products, :new_arrival)
  end
end
