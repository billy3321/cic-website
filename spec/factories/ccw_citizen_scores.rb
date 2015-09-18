FactoryGirl.define do
  factory :ccw_citizen_score do
    ad_session { FactoryGirl.create(:ad_session) }
    total 20
    average { rand(20) }
    ccw_link 'http://www.google.com.tw'
  end
end
