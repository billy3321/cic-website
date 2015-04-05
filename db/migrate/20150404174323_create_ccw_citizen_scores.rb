class CreateCcwCitizenScores < ActiveRecord::Migration
  def change
    create_table :ccw_citizen_scores do |t|
      t.belongs_to :ad_session
      t.belongs_to :committee
      t.float :total
      t.float :average
    end
  end
end
