FactoryGirl.define do
  factory :election do
    ad { FactoryGirl.create(:ad) }
    legislator { FactoryGirl.create(:legislator) }
    party { FactoryGirl.create(:party) }
    sequence(:constituency)  { |n| "Constituency #{n}" }
    county { FactoryGirl.create(:county) }
    after :create do |election|
      create :district, county: election.county
    end
  end
end
