require "rails_helper"

describe Legislator do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :legislator
    }.to change { Legislator.count }.by(1)
  end

  it "should order by name asc" do
    legislator1 = FactoryGirl.create(:legislator, name: 'Legislator 1')
    legislator2 = FactoryGirl.create(:legislator, name: 'Legislator 2')
    expect(Legislator.all).to eq([legislator1, legislator2])
  end

  it "current_legislators work" do
    FactoryGirl.create(:legislator, in_office: true)
    FactoryGirl.create(:legislator, in_office: false)
    FactoryGirl.create(:legislator, in_office: true)

    expect(Legislator.current_legislators.count).to eq(2)
  end

  it "current_party work" do
    legislator1 = FactoryGirl.create(:legislator)
    party1 = legislator1.elections.first.party
    party1.abbreviation = 'KMT'
    party1.save
    legislator2 = FactoryGirl.create(:legislator)
    party2 = legislator2.elections.first.party
    party2.abbreviation = 'KMT'
    party2.save
    legislator3 = FactoryGirl.create(:legislator)
    party3 = legislator3.elections.first.party
    party3.abbreviation = nil
    party3.save
    expect(Legislator.current_party(nil).count).to eq(1)
    expect(Legislator.current_party('KMT').count).to eq(2)
  end

  it "order_by_entries_created work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    legislator3 = FactoryGirl.create(:legislator)
    FactoryGirl.create(:entry, legislators: [legislator1], created_at: 1.day.ago)
    FactoryGirl.create(:entry, legislators: [legislator2], created_at: 2.days.ago)
    expect(Legislator.order_by_entries_created).to eq([legislator1, legislator2])
  end

  it "order_by_interpellations_created work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    legislator3 = FactoryGirl.create(:legislator)
    FactoryGirl.create(:interpellation, legislators: [legislator1], created_at: 1.day.ago)
    FactoryGirl.create(:interpellation, legislators: [legislator2], created_at: 2.days.ago)
    expect(Legislator.order_by_interpellations_created).to eq([legislator1, legislator2])
  end

  it "order_by_videos_created work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    legislator3 = FactoryGirl.create(:legislator)
    FactoryGirl.create(:video_news, legislators: [legislator1], created_at: 1.day.ago)
    FactoryGirl.create(:video_news, legislators: [legislator2], created_at: 2.days.ago)
    expect(Legislator.order_by_videos_created).to eq([legislator1, legislator2])
  end

  it "has_records has_no_record work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    legislator3 = FactoryGirl.create(:legislator)
    FactoryGirl.create(:interpellation, legislators: [legislator1])
    FactoryGirl.create(:video_news, legislators: [legislator1])
    FactoryGirl.create(:entry, legislators: [legislator2])
    expect(Legislator.has_records).to eq([legislator1, legislator2])
    expect(Legislator.has_no_record).to eq([legislator3])
    expect(legislator1.has_record?).to eq(true)
    expect(legislator2.has_record?).to eq(true)
    expect(legislator3.has_record?).to eq(false)
  end

  it "order_by_entries_count work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    legislator3 = FactoryGirl.create(:legislator)
    FactoryGirl.create(:entry, legislators: [legislator1])
    FactoryGirl.create(:entry, legislators: [legislator1])
    FactoryGirl.create(:entry, legislators: [legislator2])
    expect(Legislator.order_by_entries_count).to eq([legislator1, legislator2])
  end

  it "order_by_interpellations_count work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    legislator3 = FactoryGirl.create(:legislator)
    FactoryGirl.create(:interpellation, legislators: [legislator1])
    FactoryGirl.create(:interpellation, legislators: [legislator1])
    FactoryGirl.create(:interpellation, legislators: [legislator2])
    expect(Legislator.order_by_interpellations_count).to eq([legislator1, legislator2])
  end

  it "order_by_videos_count work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    legislator3 = FactoryGirl.create(:legislator)
    FactoryGirl.create(:video_news, legislators: [legislator1])
    FactoryGirl.create(:video_news, legislators: [legislator1])
    FactoryGirl.create(:video_news, legislators: [legislator2])
    expect(Legislator.order_by_videos_count).to eq([legislator1, legislator2])
  end

  it "party work" do
    legislator1 = FactoryGirl.create(:legislator)
    legislator2 = FactoryGirl.create(:legislator)
    party_nil = FactoryGirl.create(:party, abbreviation: nil)
    ad1 = legislator1.ads.first
    ad2 = legislator2.ads.first
    ad1.vote_date = 2.year.ago
    ad1.save
    ad2.vote_date = 1.years.ago
    ad2.save
    election2 = legislator2.elections.first
    party2 = election2.party
    election2.legislator = legislator1
    election2.save
    #now legislator1 has 2 election, legislator2 has no election
    expect(legislator1.party).to eq(party2)
    expect(legislator2.party).to eq(party_nil)
  end
end