FactoryGirl.define do
  factory :entry do
    sequence(:title)  { |n| "Entry #{n}" }
    sequence(:content) { |n| "Entry_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislator { FactoryGirl.create(:legislator) }
  end
end