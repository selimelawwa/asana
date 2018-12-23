class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.boolean :cart, default: true
      t.decimal :total_cost
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :promo_applied, default: false
      t.integer :status
      t.timestamps
    end
  end
end
