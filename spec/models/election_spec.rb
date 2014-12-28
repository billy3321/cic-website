require 'spec_helper'

describe Election do
  it "#factory_creat_success" do
    legislator = FactoryGirl.create(:legislator)
    expect {
      FactoryGirl.create :election, legislator: legislator
    }.to change { Election.count }.by(1)
  end

  it "should order by ad vote_date asc" do
    ad1 = FactoryGirl.create(:ad, vote_date: Date.today)
    ad2 = FactoryGirl.create(:ad, vote_date: 1.year.ago)
    ad3 = FactoryGirl.create(:ad, vote_date: 2.years.ago)
    legislator = FactoryGirl.create(:legislator)
    Election.delete_all
    election1 = FactoryGirl.create(:election, legislator: legislator, ad: ad1)
    election2 = FactoryGirl.create(:election, legislator: legislator, ad: ad2)
    election3 = FactoryGirl.create(:election, legislator: legislator, ad: ad3)

    Election.ordered_by_vote_date.should == [election3, election2, election1]
  end
end
