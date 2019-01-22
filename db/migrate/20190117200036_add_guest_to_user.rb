class AddGuestToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :guest, :boolean, default: false unless column_exists?(:users, :guest)
  end
end
