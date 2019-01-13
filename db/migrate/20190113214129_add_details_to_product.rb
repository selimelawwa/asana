class AddDetailsToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :fabric_details, :string
    add_column :products, :model_wearing, :string
  end
end
