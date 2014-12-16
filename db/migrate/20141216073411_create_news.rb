class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.integer :author_id
      t.string :source
      t.date :date

      t.timestamps
    end
  end
end
