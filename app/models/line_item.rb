class LineItem < ApplicationRecord
  with_options inverse_of: :line_items do
    belongs_to :order
    belongs_to :variant
  end
  
  before_save :set_cost

  before_save :validate_order_not_confirmed

  validates :quantity, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5,  only_integer: true }

  def set_cost
    self.cost = variant.product.price
  end

  def verify_cost
    if cost != variant.product.price && order.cart?
      update(cost: variant.product.price)
    end
  end

  def total_cost
    quantity * cost
  end

  def validate_order_not_confirmed
    if order.cart == false
      errors.add(:order, "Cant edit/delete order items after order confirmed")
      throw :abort
    end
  end
end
