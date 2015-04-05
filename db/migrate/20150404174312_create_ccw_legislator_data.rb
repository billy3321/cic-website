class CreateCcwLegislatorData < ActiveRecord::Migration
  def change
    create_table :ccw_legislator_data do |t|
      t.belongs_to :legislator_committee
      t.integer :ys_attend_count
      t.integer :sc_attend_count
      t.integer :first_proposal_count
      t.integer :not_first_proposal_count
      t.integer :budgetary_count
      t.integer :auditing_count
      t.float :citizen_score
      t.float :new_sunshine_bills
      t.float :modify_sunshine_bills
      t.float :budgetary_deletion_passed
      t.float :budgetary_deletion_impact
      t.float :budgetary_deletion_special
      t.float :special
      t.float :conflict_expose
      t.float :allow_visitor
      t.float :human_rights_infringing_bill
      t.float :human_rights_infringing_budgetary
      t.float :judicial_case
      t.float :disorder
    end
  end
end
