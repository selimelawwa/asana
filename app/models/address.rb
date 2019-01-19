class Address < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :user
  belongs_to :city

  after_save :ensure_only_1_default_address
  before_create :set_to_default_address_if_first

  with_options presence: true,length: { is: 11 }, numericality: { only_integer: true } do
    validates :mobile
  end

  validates :address, presence: true, length: {minimum: 10}
  validates :city, presence: true
  validates_format_of :mobile, with: /\A01[0-9]{9}/

  def ensure_only_1_default_address
    if default_addresses_changed? || (default_addresses == true)
      self.class.where(user_id: user_id, default_addresses: true).each do |a|
        a.update(default_addresses: false)
      end
    end
  end

  def set_to_default_address_if_first
    if self.class.where(user_id: user_id).count == 0
      self.default_addresses = true
    end
  end
end
