class Jumbotron < ApplicationRecord
  has_attached_file :photo
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates :photo, presence: true
  validate :validate_categories_not_the_same

  def validate_categories_not_the_same
    if category_id_1 == category_id_2
      errors.add(:category_id_2, "Category 1 Can't be the same as Category 2")
      throw :abort
    end
  end
end
