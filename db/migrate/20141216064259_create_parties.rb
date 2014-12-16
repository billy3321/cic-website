class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.string :image
      t.string :abbreviation

      t.timestamps
    end
  end
end
