class Address < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :user

  with_options presence: true,length: { is: 11 }, numericality: { only_integer: true } do
    validates :mobile
  end

  validates :address, presence: true, length: {minimum: 10}

  validates_format_of :mobile, with: /\A01[0-9]{9}/

end
