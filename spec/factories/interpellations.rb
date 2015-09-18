FactoryGirl.define do
  factory :interpellation do
    sequence(:title)  { |n| "Interpellation #{n}" }
    sequence(:content) { |n| "Interpellation_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislators {[ FactoryGirl.create(:legislator) ]}
    committee { FactoryGirl.create(:committee) }
    ad_session { FactoryGirl.create(:ad_session) }
    sequence(:comment) { |n| "Interpellation_#{n} Comment"}
    sequence(:date) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).days }
  end

  factory :interpellation_record, parent: :interpellation do
    interpellation_type "record"
    record_url 'http://www.google.com.tw'
  end

  factory :interpellation_ivod, parent: :interpellation do
    interpellation_type "ivod"
    ivod_url 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    committee { FactoryGirl.create(:committee) }
  end
end