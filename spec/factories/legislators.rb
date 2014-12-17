FactoryGirl.define do
  factory :legislator do
    sequence(:name)  { |n| "Legislator #{n}" }
    in_office true
  end
end
