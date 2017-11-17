class FacilityInfo < ApplicationRecord
  belongs_to :facility
  has_many :available_unit_types

  store :st_processor_info, accessors: %i(cs_processor cs_user_name cs_password cs_property_code cs_url1 cs_url2),
                            coder: JSON
end
