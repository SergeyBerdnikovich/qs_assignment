FactoryBot.define do
  factory :facility_info do
    association :facility

    success false
    cs_site_name 'Site Name'
    cs_site_address 'Site Address'
    cs_site_city 'Site City'
    cs_site_state 'Site State'
    cs_site_zip 'Site Zip'
    cs_site_phone 'Site Phone'
    cs_site_email 'site_email@gmail.com'
    cs_smtp_name 'Smtp Name'
    cs_smtp_user 'Smtp User'
    cs_smtp_password 'Smtp Password'
    cs_smtp_need_auth 'Smtp need auth'
    cs_allow_payment_one_week_before_auction 'test'
    cs_allow_rent_unit 'allow'
    cs_allow_reserve 'allow'
    cs_allow_edit_tenant_info 'allow'
    cs_advertising 'test'
    i_advertising_days 0
    cs_smtp_port 25
    cs_smtp_secure_log_on false
    st_processor_info { { test: :test } }
  end
end
