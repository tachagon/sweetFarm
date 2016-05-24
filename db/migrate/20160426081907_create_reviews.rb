class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :reviewer_id
      t.integer :reviewed_id
      t.references :deal, index: true, foreign_key: true
      t.integer :rating
      t.text :comment

      t.timestamps null: false
    end
  end
end
