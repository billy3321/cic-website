require 'spec_helper'

describe AdSession do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :ad_session
    }.to change { AdSession.count }.by(1)
  end

  it "should order by date_start desc" do
    ad_session1 = FactoryGirl.create(:ad_session, date_start: 1.year.ago)
    ad_session2 = FactoryGirl.create(:ad_session, date_start: 2.years.ago)
    ad_session3 = FactoryGirl.create(:ad_session, date_start: 3.years.ago)
    AdSession.all.should == [ad_session1, ad_session2, ad_session3]
  end

  it "should get current ad session" do
    ad_session1 = FactoryGirl.create(:ad_session, date_start: 1.year.ago, date_end: nil)
    ad_session2 = FactoryGirl.create(:ad_session, date_start: 2.years.ago, date_end: 1.year.ago)
    ad_session3 = FactoryGirl.create(:ad_session, date_start: 3.years.ago, date_end: 2.years.ago)
    AdSession.current_ad_session(6.months.ago).should == [ad_session1]
    AdSession.current_ad_session(18.months.ago).should == [ad_session2]
  end
end
