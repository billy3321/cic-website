class CreateLegislatorsVideos < ActiveRecord::Migration
  def change
    create_table :legislators_videos, id: false do |t|
      t.belongs_to :legislator
      t.belongs_to :video
    end
  end
end
