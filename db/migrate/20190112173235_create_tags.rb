class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end
    create_table :products_tags, id: false do |t|
      t.belongs_to :product, index: true
      t.belongs_to :tag, index: true
      t.timestamps
    end
  end
end
