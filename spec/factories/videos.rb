FactoryGirl.define do
  factory :video do
    sequence(:title)  { |n| "Video #{n}" }
    sequence(:content) { |n| "Video_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislator { FactoryGirl.create(:legislator) }
    committee { FactoryGirl.create(:committee) }
    ad_session { FactoryGirl.create(:ad_session) }
    sequence(:source_url) { |n| "http://source_${n}/url"}
    sequence(:date) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).days }
    youtube_url ""
  end
end
