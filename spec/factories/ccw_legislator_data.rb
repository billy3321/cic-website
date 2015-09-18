FactoryGirl.define do
  factory :ccw_legislator_datum do
    legislator_committee { FactoryGirl.create(:legislator_committee) }
    yc_attendance { rand(30) }
    sc_attendance { rand(30) }
    sc_interpellation_count { rand(30) }
    first_proposal_count { rand(30) }
    not_first_proposal_count { rand(30) }
    budgetary_count { rand(30) }
    auditing_count { rand(30) }
    citizen_score { rand(30) }
    new_sunshine_bills { rand(30) }
    modify_sunshine_bills { rand(30) }
    budgetary_deletion_passed { rand(30) }
    budgetary_deletion_impact { rand(30) }
    budgetary_deletion_special { rand(30) }
    special { rand(30) }
    conflict_expose { rand(30) }
    allow_visitor { rand(30) }
    human_rights_infringing_bill { rand(30) }
    human_rights_infringing_budgetary { rand(30) }
    judicial_case { rand(30) }
    disorder { rand(30) }
  end
end
