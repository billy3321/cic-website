class CreateEntriesKeywords < ActiveRecord::Migration
  def change
    create_table :entries_keywords, id: false do |t|
      t.belongs_to :keyword
      t.belongs_to :entry
    end

    add_index :entries_keywords, [:keyword_id, :entry_id], :unique => true
  end
end
