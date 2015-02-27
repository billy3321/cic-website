class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.integer :county_id
      t.string :name
    end
  end
end
