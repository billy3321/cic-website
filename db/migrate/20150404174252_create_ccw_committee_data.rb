class CreateCcwCommitteeData < ActiveRecord::Migration
  def change
    create_table :ccw_committee_data do |t|
      t.belongs_to :ad_session
      t.belongs_to :committee
      t.integer :should_attend_count
      t.float :actually_average_attend_count
      t.integer :avaliable_interpellation_count
      t.float :actually_average_interpellation_count
    end
  end
end
