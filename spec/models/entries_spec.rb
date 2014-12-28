require "spec_helper"

describe Entry do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :entry
    }.to change { Entry.count }.by(1)
  end

  it "order created_at desc work" do
    entry1 = FactoryGirl.create(:entry, created_at: 1.day.ago)
    entry2 = FactoryGirl.create(:entry, created_at: Time.now)
    expect(Entry.all).to eq([entry2, entry1])
  end

  it "published work" do
    entry1 = FactoryGirl.create(:entry)
    entry2 = FactoryGirl.create(:entry, published: false)
    expect(Entry.published).to eq([entry1])
  end

  it "created_in_time_count created_after work" do
    entry1 = FactoryGirl.create(:entry, created_at: Time.now)
    entry2 = FactoryGirl.create(:entry, created_at: 2.month.ago)
    entry3 = FactoryGirl.create(:entry, created_at: 4.months.ago)
    expect(Entry.created_in_time_count(5.months.ago, 4.months)).to eq(2)
    expect(Entry.created_after(3.months.ago)).to eq([entry1, entry2])
  end

  it "validate has_at_least_one_legislator work" do
    entry = FactoryGirl.build(:entry)
    entry.legislators = []
    expect{entry.save!}.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: 必須加入至少一名立法委員！')
  end

  it "validate is_source_url work" do
    entry = FactoryGirl.build(:entry)
    entry.source_url = "not url string"
    expect{entry.save!}.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: 新聞來源網址錯誤')
  end
end