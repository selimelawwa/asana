class CreateSlides < ActiveRecord::Migration[5.2]
  def change
    create_table :slides do |t|
      t.attachment :photo
      t.text :description
      t.timestamps
    end
  end
end
