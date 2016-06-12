class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.references :deal, index: true, foreign_key: true
      t.references :announcement, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
