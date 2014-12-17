FactoryGirl.define do
  factory :video do
    sequence(:title)  { |n| "Video #{n}" }
    sequence(:content) { |n| "Video_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislator { FactoryGirl.create(:legislator) }
  end
end