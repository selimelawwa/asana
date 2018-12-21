class Image < ApplicationRecord

  has_many :variant_images
  has_many :variants, through: :variant_images
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" },
    :convert_options => {:medium => "-gravity center -extent 300x300"}

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

end
