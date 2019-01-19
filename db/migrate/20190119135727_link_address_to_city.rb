class LinkAddressToCity < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :city
    add_reference :addresses, :city, index: true, foreign_key: true
  end
end
