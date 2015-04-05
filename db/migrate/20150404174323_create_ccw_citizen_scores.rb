class CreateCcwCitizenScores < ActiveRecord::Migration
  def change
    create_table :ccw_citizen_scores do |t|
      t.belongs_to :ad_session
      t.float :total
      t.float :average
      t.string :ccw_link
    end
  end
end
