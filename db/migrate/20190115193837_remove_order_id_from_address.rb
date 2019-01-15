class RemoveOrderIdFromAddress < ActiveRecord::Migration[5.2]
  def change
    remove_reference :addresses, :order, index:true, foreign_key: true
    add_reference :orders, :address, index: true, foreign_key: true
  end
end
