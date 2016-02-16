class CreateSingleSignOns < ActiveRecord::Migration
  def change
    create_table :single_sign_ons do |t|
      t.string :provider
      t.string :uid
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
