class Product < ApplicationRecord
  has_attached_file :main_photo, styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :main_photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]

end
