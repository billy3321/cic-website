class AddCountyIdToElections < ActiveRecord::Migration
  def change
    add_column :elections, :county_id, :integer
  end
end
