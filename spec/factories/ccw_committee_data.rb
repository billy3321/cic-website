FactoryGirl.define do
  factory :ccw_committee_datum do
    ad_session { FactoryGirl.create(:ad_session) }
    committee { FactoryGirl.create(:committee) }
    should_attendance { rand(30) }
    actually_average_attendance { rand(20) }
  end

  factory :ccw_committee_datum_yc, parent: :iccw_committee_datum do
  end

  factory :ccw_committee_datum_sc, parent: :iccw_committee_datum do
    avaliable_interpellation_count { rand(30) }
    actually_average_interpellation_count { rand(20) }
  end
end
