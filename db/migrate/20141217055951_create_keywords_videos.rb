class CreateKeywordsVideos < ActiveRecord::Migration
  def change
    create_table :keywords_videos, id: false do |t|
      t.belongs_to :keyword
      t.belongs_to :video
    end

    add_index :keywords_videos, [:keyword_id, :video_id], :unique => true
  end
end
