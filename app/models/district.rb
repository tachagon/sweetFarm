class District < ActiveRecord::Base
  self.table_name = "district"
  self.primary_key = "DISTRICT_ID"

  belongs_to :geography, foreign_key: "GEO_ID"
  belongs_to :province, foreign_key: "PROVINCE_ID"
  belongs_to :amphur, foreign_key: "AMPHUR_ID"
end
