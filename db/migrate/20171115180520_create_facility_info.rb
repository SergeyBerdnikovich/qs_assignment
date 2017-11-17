class CreateFacilityInfo < ActiveRecord::Migration[5.0]
  def change
    create_table :facility_infos do |t|
      t.references :facility
      t.boolean    :success,                                  null: false, default: false
      t.string     :cs_site_name,                             null: false, default: ''
      t.string     :cs_site_address,                          null: false, default: ''
      t.string     :cs_site_city,                             null: false, default: ''
      t.string     :cs_site_state,                            null: false, default: ''
      t.string     :cs_site_zip,                              null: false, default: ''
      t.string     :cs_site_phone,                            null: false, default: ''
      t.string     :cs_site_email,                            null: false, default: ''
      t.string     :cs_smtp_name,                             null: false, default: ''
      t.string     :cs_smtp_user,                             null: false, default: ''
      t.string     :cs_smtp_password,                         null: false, default: ''
      t.string     :cs_smtp_need_auth,                        null: false, default: ''
      t.string     :cs_allow_payment_one_week_before_auction, null: false, default: ''
      t.string     :cs_allow_rent_unit,                       null: false, default: ''
      t.string     :cs_allow_reserve,                         null: false, default: ''
      t.string     :cs_allow_edit_tenant_info,                null: false, default: ''
      t.string     :cs_advertising,                           null: false, default: ''
      t.integer    :i_advertising_days,                       null: false, default: 0
      t.integer    :cs_smtp_port,                             null: false, default: 25
      t.boolean    :cs_smtp_secure_log_on,                    null: false, default: false
      t.text       :st_processor_info,                        null: false, default: '{}'
    end
  end
end
