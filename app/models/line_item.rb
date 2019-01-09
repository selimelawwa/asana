class LineItem < ApplicationRecord
  with_options inverse_of: :line_items do
    belongs_to :order
    belongs_to :variant
  end
  
  before_save :set_cost

  validates :quantity, numericality: { less_than_or_equal_to: 5,  only_integer: true }

  def set_cost
    self.cost = variant.product.price
  end

  def total_cost
    quantity * cost
  end
end
