class Order < ApplicationRecord
  has_many :line_items, -> { order(:created_at) }, inverse_of: :order, dependent: :destroy
  has_many :variants, through: :line_items
  has_many :products, through: :variants
  has_many :addresses
  belongs_to :user

  enum status: %i[cart address confirmed delivered canceled]
  
  scope :completed, -> { where(cart: false) }

  before_create :set_default_status

  def set_default_status
    self.status = 'cart'
  end

  def current_total_cost
    line_items.map(&:total_cost).inject(0){|sum,x| sum + x }
  end

  def remove_order_id_from_other_addresses(address_id)
    addresses.where.not(id: address_id).each do |a|
      a.update(order_id: nil)
    end
  end

  def valid_for_finalize?
    line_items.any?
  end

  def get_delivery_address
    addresses.first
  end
end
