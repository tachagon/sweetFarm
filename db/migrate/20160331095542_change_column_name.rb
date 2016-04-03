class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :announcements, :type, :role
  end
end
