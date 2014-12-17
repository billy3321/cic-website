FactoryGirl.define do
  factory :election do
    ad { FactoryGirl.create(:ad) }
    legislator { FactoryGirl.create(:legislator) }
    party { FactoryGirl.create(:party) }
    sequence(:constituency)  { |n| "Constituency #{n}" }
  end
end
