class CreateLegislatorsQuestions < ActiveRecord::Migration
  def change
    create_table :legislators_questions, id: false  do |t|
      t.belongs_to :legislator
      t.belongs_to :question
    end
  end
end
