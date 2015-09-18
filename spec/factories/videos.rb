FactoryGirl.define do
  factory :video do
    sequence(:title)  { |n| "Video #{n}" }
    sequence(:content) { |n| "Video_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislators {[ FactoryGirl.create(:legislator) ]}
    ad_session { FactoryGirl.create(:ad_session) }
    source_url "http://www.google.com"
    sequence(:date) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).days }
    youtube_url 'https://www.youtube.com/watch?v=Gh1zJVwHhjw'
  end

  factory :video_news, parent: :video do
    video_type "news"
    source_name "新聞"
  end

  factory :video_ivod, parent: :video do
    video_type "ivod"
    ivod_url 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    committee { FactoryGirl.create(:committee) }
  end
end