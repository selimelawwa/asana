class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.belongs_to :variant, index: true
      t.attachment :image
      t.string :alt_text
      t.timestamps
    end
  end
end
