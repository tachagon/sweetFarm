class Zipcode < ActiveRecord::Base
  self.table_name = "zipcode"
  self.primary_key = "ZIPCODE_ID"

  belongs_to :province, foreign_key: "PROVINCE_ID"
  belongs_to :amphur, foreign_key: "AMPHUR_ID"
  belongs_to :district, foreign_key: "DISTRICT_ID"
end
