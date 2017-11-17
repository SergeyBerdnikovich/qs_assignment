FactoryBot.define do
  factory :available_unit_type do
    association :facility_info

    i_type_id 123
    cs_type_description 'Description'
    d_price 10.0
    availability 1
    cs_last_unit 'last unit'
  end
end
