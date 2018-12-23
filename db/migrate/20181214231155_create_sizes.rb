class CreateSizes < ActiveRecord::Migration[5.2]
  def change
    create_table :sizes do |t|
      t.string :name
      t.integer :size_for
      t.timestamps
    end
  end
end
