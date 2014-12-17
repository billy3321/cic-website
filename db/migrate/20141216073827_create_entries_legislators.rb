class CreateEntriesLegislators < ActiveRecord::Migration
  def change
    create_table :entries_legislators, id: false do |t|
      t.belongs_to :legislator
      t.belongs_to :entry
    end

    add_index :entries_legislators, [:legislator_id, :entry_id], :unique => true
  end
end
