class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :committee_id
      t.text :meeting_description
      t.string :youtube_url
      t.string :youtube_id
      t.string :image
      t.string :ivod_url
      t.string :source_url
      t.date :date

      t.timestamps
    end
  end
end
