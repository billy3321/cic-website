FactoryGirl.define do
  factory :legislator_committee do
    legislator { FactoryGirl.create(:legislator) }
    ad_session { FactoryGirl.create(:ad_session) }
    committee { FactoryGirl.create(:committee_sc) }
    convener false
  end

  factory :legislator_committee_yc, parent: :legislator_committee do
    committee { FactoryGirl.create(:committee_yc) }
  end
end
