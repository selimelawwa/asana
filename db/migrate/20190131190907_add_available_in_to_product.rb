class AddAvailableInToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :available_in, :string unless column_exists?(:products, :available_in)
  end
end
