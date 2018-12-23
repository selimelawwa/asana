class AddImageToColor < ActiveRecord::Migration[5.2]
  def up
    add_attachment :colors, :photo
  end

  def down
    remove_attachment :colors, :photo
  end
end
