class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name
      t.decimal :default_shipping_price, :precision => 8, :scale => 2
      t.timestamps
    end
    create_table :cities do |t|
      t.string :name
      t.decimal :shipping_price, :precision => 8, :scale => 2
      t.belongs_to :country, index: true
      t.timestamps
    end
  end
end
