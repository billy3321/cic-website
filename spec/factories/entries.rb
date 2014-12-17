FactoryGirl.define do
  factory :entry do
    sequence(:title)  { |n| "Entry #{n}" }
    sequence(:content) { |n| "Entry_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislator { FactoryGirl.create(:legislator) }
    sequence(:source_url) { |n| "http://source_${n}/url"}
    sequence(:date) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).days }
  end
end
