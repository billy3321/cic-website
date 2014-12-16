class CreateEntriesLegislators < ActiveRecord::Migration
  def change
    create_table :entries_legislators, id: false do |t|
      t.belongs_to :legislator
      t.belongs_to :entry
    end
  end
end
