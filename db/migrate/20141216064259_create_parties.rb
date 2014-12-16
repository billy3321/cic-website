class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.text :name
      t.text :image
      t.text :abbreviation

      t.timestamps
    end
  end
end
