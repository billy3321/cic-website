FactoryGirl.define do
  factory :ad_session do
    sequence(:name)  { |n| "AdSession #{n}" }
    date_start "2014-01-01"
    date_end "2014-06-01"
    ad { FactoryGirl.create(:ad) }
  end
end
