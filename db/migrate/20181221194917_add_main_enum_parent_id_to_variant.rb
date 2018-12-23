class AddMainEnumParentIdToVariant < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :kind, :int
    add_reference :variants, :main, index: true
  end
end
