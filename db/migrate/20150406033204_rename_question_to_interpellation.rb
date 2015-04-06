class RenameQuestionToInterpellation < ActiveRecord::Migration
  def change
    remove_index :legislators_questions, [:legislator_id, :question_id]
    remove_index :keywords_questions, [:keyword_id, :question_id]

    rename_table :questions, :interpellations
    rename_table :legislators_questions, :interpellations_legislators
    rename_column :interpellations_legislators, :question_id, :interpellation_id
    rename_table :keywords_questions, :interpellations_keywords
    rename_column :interpellations_keywords, :question_id, :interpellation_id

    add_index :interpellations_legislators, [:legislator_id, :question_id], :unique => true
  end 
end
