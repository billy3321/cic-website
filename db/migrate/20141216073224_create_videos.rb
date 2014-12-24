class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :content
      t.text :video_type
      t.integer :user_id
      t.integer :committee_id
      t.integer :ad_session_id
      t.text :meeting_description
      t.string :youtube_url
      t.string :youtube_id
      t.string :image
      t.string :ivod_url
      t.string :source_url
      t.string :source_name
      t.time :time_start
      t.time :time_end
      t.date :date
      t.boolean :published, :default => true

      t.timestamps
    end
  end
end
