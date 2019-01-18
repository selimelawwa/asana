class Slide < ApplicationRecord
  has_attached_file :photo, styles: { thumb: "70x70>" }
    
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates :photo, attachment_presence: true

  validates :photo, presence: true

  before_create :validate_max_5_slides

  def validate_max_5_slides
    if self.class.count > 5
      errors.add(:max_5_sldies, "You can have max 5 Slides in system, please delete 1 before you can add a new 1")
      throw :abort
    end
  end

end
