class Color < ApplicationRecord
  has_attached_file :photo, styles: { thumb: "100x100>" },
    :convert_options => {:medium => "-gravity center -extent 300x300"}
    
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  scope :with_photo, -> { where.not(photo_file_name: nil) }
end
