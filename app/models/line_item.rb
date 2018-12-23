class LineItem < ApplicationRecord
  with_options inverse_of: :line_items do
    belongs_to :order
    belongs_to :variant
  end
end
