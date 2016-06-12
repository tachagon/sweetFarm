class AddCanePictureToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :cane_picture, :string
  end
end
