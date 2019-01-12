class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.belongs_to :order, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :default_addresses, default: false
      t.string :city
      t.string :mobile
      t.string :telephone
      t.string :address
      t.timestamps
    end
  end
end
