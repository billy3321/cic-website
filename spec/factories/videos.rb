FactoryGirl.define do
  factory :video do
    sequence(:title)  { |n| "Video #{n}" }
    sequence(:content) { |n| "Video_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislators {[ FactoryGirl.create(:legislator) ]}
    committee { FactoryGirl.create(:committee) }
    ad_session { FactoryGirl.create(:ad_session) }
    sequence(:source_url) { |n| "http://source_${n}/url"}
    sequence(:date) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).days }
    youtube_url 'https://www.youtube.com/watch?v=Gh1zJVwHhjw'
    ivod_url 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
  end
end
