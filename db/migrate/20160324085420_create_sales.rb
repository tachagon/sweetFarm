class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.float :amount
      t.float :price
      t.integer :district_id, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :expire
      t.references :sale_status, index: true, foreign_key: true
      t.boolean :show, default: true

      t.timestamps null: false
    end
  end
end
