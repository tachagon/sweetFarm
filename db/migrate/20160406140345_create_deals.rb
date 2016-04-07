class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.float :amount
      t.float :price
      t.datetime :expire
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
