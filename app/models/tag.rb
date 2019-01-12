class Tag < ApplicationRecord
  with_options presence: true,length: { minimum: 3 }, uniqueness: { case_sensitive: false } do
    validates :name
  end
end
