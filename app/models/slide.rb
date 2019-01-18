class Slide < ApplicationRecord
  has_attached_file :photo, styles: { thumb: "70x70>" }
    
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates :photo, attachment_presence: true

  validates :photo, presence: true

end
