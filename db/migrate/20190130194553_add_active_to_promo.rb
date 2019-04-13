class AddActiveToPromo < ActiveRecord::Migration[5.2]
  def change
    add_column :promos, :active, :boolean, default: false unless column_exists?(:promos, :active)
    add_column :promos, :used_times, :integer, default: 0 unless column_exists?(:promos, :used_times)
  end
end
