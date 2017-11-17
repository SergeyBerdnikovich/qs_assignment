FactoryBot.define do
  factory :available_unit do
    association :available_unit_type

    cs_unit_id '123'
    d_rent 10.0
  end
end
