class CreateVats < ActiveRecord::Migration[5.2]
  def change
    create_table :vats do |t|
      t.decimal :tax_rate, precision: 8, scale: 2, null: false, default: 0
      t.string :name
      t.timestamps
    end
  end
end
