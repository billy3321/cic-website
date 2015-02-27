class CreateDistrictsElections < ActiveRecord::Migration
  def change
    create_table :districts_elections, id: false do |t|
      t.belongs_to :district
      t.belongs_to :election
    end

    add_index :districts_elections, [:district_id, :election_id], :unique => true
  end
end
