FactoryGirl.define do
  factory :legislator do
    sequence(:name)  { |n| "Legislator #{n}" }
    election { FactoryGirl.create(:election) }
  end
end
