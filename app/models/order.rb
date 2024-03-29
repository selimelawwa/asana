class Order < ApplicationRecord
  has_many :line_items, -> { order(:created_at) }, inverse_of: :order, dependent: :destroy
  has_many :variants, through: :line_items
  has_many :products, through: :variants

  belongs_to :address, optional: true
  belongs_to :user
  belongs_to :promo, optional: true

  enum status: %i[in_cart confirmed delivered canceled]
  
  before_create :ensure_no_other_un_confirmed_orders
  before_create :set_default_status

  before_update :validate_no_out_of_stock_variants
  before_update :validate_assigned_address
  before_update :validate_promo

  def finalize
    if update(cart: false, status: 'confirmed', total_cost: final_total, confirmed_at: Time.zone.now, vat: vat_amount, shipping: shipping_fees, discount: discount_amount, total_before_discount: current_total_cost)
      decrement_variant_stocks
      increment_promo_usage if promo.present?
    end
  end

  def final_total
    total = total_after_discount
    total = total + shipping_fees if address.present?
    total + vat_amount
  end

  def discount_amount
    if promo_id.present?
      current_total_cost * ( promo.discount_rate.to_f / 100 )
    else
      0
    end
  end
  
  def total_after_discount
    current_total_cost - discount_amount
  end

  def shipping_fees
    address.city.shipping_price
  end

  def vat_amount
    total = current_total_cost
    total = total + shipping_fees if address.present?
    total * Vat.default.tax_rate_percentage
  end

  def increment_promo_usage
    usage = promo.used_times
    new_usage = usage + 1
    promo.update(used_times: new_usage)
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

  def validate_assigned_address
    if cart_changed? && !address.presence
      errors.add(:address_not_selected, "Please select an address!")
      throw :abort
    end
  end

  def validate_promo
    if promo_id.present? && !promo&.active?
      errors.add(:promo_inactive, "Promo code is in active!")
      throw :abort
    elsif promo_id.present? && user.orders.where(promo_id: promo_id).where("id != ?",self.id).present?
      errors.add(:promo_used_before, "You have already used this promo code!")
      throw :abort
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
      errors.add(:base, "Cant create a new order while old one is not confirmed.")
      throw :abort
    end
  end
end
