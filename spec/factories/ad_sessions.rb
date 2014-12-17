FactoryGirl.define do
  factory :ad_session do
    sequence(:name)  { |n| "AdSession #{n}" }
    sequence(:date_start) { |n| Date.today - ( 6.months * ( n )) }
    sequence(:date_end) { |n| Date.today - ( 6.months * ( n - 1 )) }
    ad { FactoryGirl.create(:ad) }
  end
end
