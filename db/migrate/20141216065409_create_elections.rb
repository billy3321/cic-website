class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.integer :legislator_id
      t.text :constituency
      t.references :ad, index: true

      t.timestamps
    end
  end
end
