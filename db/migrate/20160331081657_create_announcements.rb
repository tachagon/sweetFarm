class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.float :amount
      t.float :price
      t.string :type
      t.datetime :expire
      t.boolean :show, default: true
      t.references :user, index: true, foreign_key: true
      t.integer :district_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
