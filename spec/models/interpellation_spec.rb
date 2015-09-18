require "rails_helper"

describe Interpellation do
  it "#factory_creat_ivod_success" do
    expect {
      FactoryGirl.create :interpellation_ivod
    }.to change { Interpellation.count }.by(1)
  end

  it "#factory_creat_record_success" do
    expect {
      FactoryGirl.create :interpellation_record
    }.to change { Interpellation.count }.by(1)
  end

  it "#ivod_update_vod_work" do
    committee = FactoryGirl.create(:committee, :name => '內政委員會')
    legislator = FactoryGirl.create(:legislator, :name => '陳節如')
    interpellation = FactoryGirl.build :interpellation_ivod
    interpellation.ivod_url = 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    interpellation.update_ivod_values
    expect(interpellation.date).to eq(Date.parse('2014-10-08'))
    expect(interpellation.committee).to eq(committee)
    expect(interpellation.legislators).to include(legislator)
    expect(interpellation.ivod_url).to eq('http://ivod.ly.gov.tw/Play/VOD/77018/1M')
  end

  it "#ivod_update_full_work" do
    committee = FactoryGirl.create(:committee, :name => '社會福利及衛生環境委員會')
    interpellation = FactoryGirl.build :interpellation_ivod
    interpellation.ivod_url = 'http://ivod.ly.gov.tw/Play/Full/7648/300K'
    interpellation.update_ivod_values
    #raise v.inspect
    expect(interpellation.date).to eq(Date.parse('2014-04-10'))
    expect(interpellation.committee).to eq(committee)
    expect(interpellation.ivod_url).to eq('http://ivod.ly.gov.tw/Play/Full/7648/1M')
    expect(interpellation.meeting_description).to match("立法院第8屆第5會期社會福利及衛生環境委員會第13次全體委員會議")
  end

  it "order created_at desc work" do
    interpellation1 = FactoryGirl.create(:interpellation_ivod, created_at: 1.day.ago)
    interpellation2 = FactoryGirl.create(:interpellation_record, created_at: Time.now)
    expect(Interpellation.all).to eq([interpellation2, interpellation1])
  end

  it "published work" do
    interpellation1 = FactoryGirl.create(:interpellation_ivod)
    interpellation2 = FactoryGirl.create(:interpellation_record, published: false)
    expect(Interpellation.published).to eq([interpellation1])
  end

  it "created_in_time_count created_after work" do
    interpellation1 = FactoryGirl.create(:interpellation_record, created_at: Time.now)
    interpellation2 = FactoryGirl.create(:interpellation_ivod, created_at: 2.month.ago)
    interpellation3 = FactoryGirl.create(:interpellation_record, created_at: 4.months.ago)
    expect(Interpellation.created_in_time_count(5.months.ago, 4.months)).to eq(2)
    expect(Interpellation.created_after(3.months.ago)).to eq([interpellation1, interpellation2])
  end

  it "validate has_at_least_one_legislator work" do
    interpellation = FactoryGirl.build(:interpellation_record)
    interpellation.legislators = []
    expect{interpellation.save!}.to raise_error(ActiveRecord::RecordInvalid,'校驗失敗: 必須填寫立委姓名！')
  end

  it "validate is_ivod_url work" do
    interpellation = FactoryGirl.build(:interpellation_ivod)
    interpellation.ivod_url = "wrong ivod url"
    expect{interpellation.save!}.to raise_error(ActiveRecord::RecordInvalid,'校驗失敗: ivod網址錯誤')
    interpellation.ivod_url = "http://ivod.ly.gov.tw/Play/VOD/300K"
    interpellation.save
    expect(interpellation.errors.messages[:base].first).to eq('ivod網址錯誤')
    expect(interpellation.ivod_url).to eq(nil)
  end

end
