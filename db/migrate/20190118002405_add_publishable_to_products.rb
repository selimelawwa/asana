class AddPublishableToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :published, :boolean, default: false
  end
end
