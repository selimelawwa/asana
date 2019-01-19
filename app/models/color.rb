class Color < ApplicationRecord
  has_attached_file :photo, styles: { thumb: "100x100>" }
    
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates :photo, presence: true

  scope :with_photo, -> { where.not(photo_file_name: nil) }
end
