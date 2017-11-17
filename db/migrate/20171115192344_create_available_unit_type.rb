class CreateAvailableUnitType < ActiveRecord::Migration[5.0]
  def change
    create_table :available_unit_types do |t|
      t.references :facility_info
      t.integer    :i_type_id,           null: false, index: true
      t.string     :cs_type_description, null: false, default: ''
      t.float      :d_price,             null: false, default: 0.0
      t.integer    :availability,        null: false, default: 0
      t.string     :cs_last_unit,        null: false, default: ''
    end
  end
end
