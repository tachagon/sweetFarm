class SaleStatus < ActiveRecord::Base
  has_many :sales, dependent: :destroy
end
