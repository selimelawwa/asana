class ChangeLineItemDefaultToZero < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:line_items, :quantity, false)
    change_column_default(:line_items, :quantity, 0)
  end
end
