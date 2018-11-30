class AddKindAndParentIdToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :kind, :int
    add_reference :categories, :parent, index: true
  end
end
