FactoryGirl.define do
  factory :question do
    sequence(:title)  { |n| "Question #{n}" }
    sequence(:content) { |n| "Question_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislator { FactoryGirl.create(:legislator) }
    committee { FactoryGirl.create(:committee) }
    ad_session { FactoryGirl.create(:ad_session) }
    ivod_url ""
    sequence(:comment) { |n| "Question_#{n} Comment"}
    sequence(:date) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).days }
  end
end
