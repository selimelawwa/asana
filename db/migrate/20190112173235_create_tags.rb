class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end
    create_table :products_tags, id: false do |t|
      t.belongs_to :products, index: true
      t.belongs_to :tags, index: true
      t.timestamps
    end
  end
end
