class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.string :source
      t.date :date

      t.timestamps
    end
  end
end
