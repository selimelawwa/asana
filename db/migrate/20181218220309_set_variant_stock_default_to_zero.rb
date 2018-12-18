class SetVariantStockDefaultToZero < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:variants, :stock, false)
    change_column_default(:variants, :stock, 0)
  end
end
