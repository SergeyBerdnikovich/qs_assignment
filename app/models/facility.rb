class Facility < ApplicationRecord
  has_one :facility_info
  has_many :available_unit_types, through: :facility_info

  delegate :id, to: :facility_info, prefix: true
end
