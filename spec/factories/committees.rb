FactoryGirl.define do
  factory :committee do
    sequence(:name)  { |n| "Committee #{n}" }
  end
end
