class Geography < ActiveRecord::Base
  self.table_name = "geography"
  self.primary_key = "GEO_ID"

  has_many :provinces, :foreign_key => "GEO_ID", :primary_key => "GEO_ID"
end
