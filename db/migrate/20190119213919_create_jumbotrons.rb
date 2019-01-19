class CreateJumbotrons < ActiveRecord::Migration[5.2]
  def change
    create_table :jumbotrons do |t|
      t.attachment :photo
      t.text :description
      t.timestamps
      t.integer :category_id_1
      t.integer :category_id_2
    end
  end
end
