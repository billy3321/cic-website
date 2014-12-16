class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.integer :author_id
      t.integer :committee_id
      t.text :meeting_description
      t.string :ivod
      t.date :date
      t.text :comment

      t.timestamps
    end
  end
end
