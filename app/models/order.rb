class Order < ApplicationRecord
  has_many :line_items, -> { order(:created_at) }, inverse_of: :order, dependent: :destroy
  has_many :variants, through: :line_items
  has_many :products, through: :variants

  belongs_to :address, optional: true
  belongs_to :user

  enum status: %i[in_cart confirmed delivered canceled]
  
  before_create :ensure_no_other_un_confirmed_orders
  before_create :set_default_status

  before_update :validate_no_out_of_stock_variants

  def finalize
    if update(cart: false, status: 'confirmed', total_cost: current_total_cost)
      decrement_variant_stocks
    end
  end

  def decrement_variant_stocks
    line_items.each do |l|
      v = l.variant
      v.stock = v.stock - l.quantity
      v.save
    end
  end

  def refresh_line_items
    line_items.each do |l|
      l.verify_cost
    end
  end
  
  def validate_no_out_of_stock_variants
    if cart_changed?
      no_stock_variants = out_of_stock_variants
      if no_stock_variants
        errors_messages = no_stock_variants.map do |v|
          difference_in_stock(v)
        end&.join('\n')
        errors.add(:out_of_stock_variants, "#{errors_messages} \nPlease remove item(s)/adjust quantity to complete order", variant_ids: no_stock_variants.ids)
        throw :abort
      end
    end
  end

  def difference_in_stock(variant)
    if variant.stock.zero?
      "#{variant.name_with_options_text} is out of stock!"
    else
      "Only #{variant.stock} items available of #{variant.name_with_options_text}"
    end
  end

  def out_of_stock_variants
    Variant.joins(line_items: :order).where(orders: {user_id: user_id, cart: true}).where('variants.stock < line_items.quantity').presence
  end

  def set_default_status
    self.status = 'in_cart'
  end

  def current_total_cost
    line_items.map(&:total_cost).inject(0){|sum,x| sum + x }
  end

  def has_line_items?
    line_items.any?
  end

  def ensure_no_other_un_confirmed_orders
    if user.orders.where(cart: true).any?
      errors.add(:base, "Cant create a new order while old one is not confirmed")
      throw :abort
    end
  end
end
