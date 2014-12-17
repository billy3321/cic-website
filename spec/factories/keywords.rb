FactoryGirl.define do
  factory :keyword do
    sequence(:name)  { |n| "Keyword #{n}" }
  end
end
