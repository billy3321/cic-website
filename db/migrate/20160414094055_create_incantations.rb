class CreateIncantations < ActiveRecord::Migration
  def change
    create_table :incantations do |t|
      t.string :title
      t.string :word
    end
  end
end
