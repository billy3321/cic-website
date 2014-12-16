class CreateLegislators < ActiveRecord::Migration
  def change
    create_table :legislators do |t|
      t.string :name
      t.text :description
      t.string :image
      t.boolean :in_office

      t.timestamps
    end
  end
end
