class AvailableUnitType < ApplicationRecord
  belongs_to :facility_info
  has_many :available_units
end
