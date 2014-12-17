FactoryGirl.define do
  factory :legislator do
    sequence(:name)  { |n| "Legislator #{n}" }
  end
end
