class Image < ApplicationRecord

  has_many :variant_images, dependent: :destroy
  has_many :variants, through: :variant_images
  
  has_attached_file :image, styles: { medium: "60%>", thumb: "70x70>" },
    convert_options: { :medium => "-quality 75" }

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates :image, attachment_presence: true

  validates :variants, presence: true

  def variant_colors
    color_ids = variants.pluck(:color_id).uniq
    colors = Color.where(id: color_ids)
    if colors.any? 
      colors_text = "#{colors.first.name}"
      Color.where(id: color_ids).drop(1).each do |c|
        colors_text += ", #{c.name}"
      end
    else
      colors_text = ""
    end
    colors_text
  end
end
