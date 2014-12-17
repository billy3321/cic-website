FactoryGirl.define do
  factory :question do
    sequence(:title)  { |n| "Question #{n}" }
    sequence(:content) { |n| "Question_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislator { FactoryGirl.create(:legislator) }
  end
end