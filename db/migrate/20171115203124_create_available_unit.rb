class CreateAvailableUnit < ActiveRecord::Migration[5.0]
  def change
    create_table :available_units do |t|
      t.references :available_unit_type
      t.string     :cs_unit_id,         null: false, default: ''
      t.float      :d_rent,             null: false, default: 0.0
    end
  end
end
