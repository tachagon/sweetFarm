class Amphur < ActiveRecord::Base
  self.table_name = "amphur"
  self.primary_key = "AMPHUR_ID"

  belongs_to :geography, foreign_key: "GEO_ID"
  belongs_to :province, foreign_key: "PROVINCE_ID"

  has_many :districts, foreign_key: "AMPHUR_ID", primary_key: "AMPHUR_ID"
end
