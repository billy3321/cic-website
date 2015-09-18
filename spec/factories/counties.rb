FactoryGirl.define do
  factory :county do
    sequence(:name)  { |n| "County #{n}" }
  end
end
