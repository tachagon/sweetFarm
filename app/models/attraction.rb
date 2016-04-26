class Attraction < ActiveRecord::Base
  belongs_to :deal
  belongs_to :announcement
end
