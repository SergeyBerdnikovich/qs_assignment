class CreateFacilities < ActiveRecord::Migration[5.0]
  def change
    create_table :facilities do |t|
      t.string :user
      t.string :password
      t.string :site

      t.timestamps
    end
  end
end
