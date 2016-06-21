class Province < ActiveRecord::Base
  self.table_name = "province"
  self.primary_key = "PROVINCE_ID"

  belongs_to :geography, foreign_key: 'GEO_ID'

  has_many :amphurs, foreign_key: "PROVINCE_ID", primary_key: "PROVINCE_ID"
  has_many :districts, foreign_key: "PROVINCE_ID", primary_key: "PROVINCE_ID"
  has_many :zipcodes, foreign_key: "PROVINCE_ID", primary_key: "PROVINCE_ID"

  has_many :announcements, through: :districts
end
