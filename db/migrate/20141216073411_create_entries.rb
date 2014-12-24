class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.string :source_url
      t.string :source_name
      t.date :date
      t.boolean :published, :default => true

      t.timestamps
    end
  end
end
