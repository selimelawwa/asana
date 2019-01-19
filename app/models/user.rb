class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders, dependent: :destroy 
  has_many :addresses, dependent: :destroy

  with_options presence: true,length: { is: 11 }, numericality: { only_integer: true } do
    validates :mobile
  end
  validates_format_of :mobile, with: /\A01[0-9]{9}/

end
