class CreateGeographies < ActiveRecord::Migration
  def change
    create_table :geographies do |t|

      t.timestamps null: false
    end
  end
end
