require "rails_helper"

describe Video do

   it "#factory_creat_video_ivod_success" do
    expect {
      FactoryGirl.create :video_ivod
    }.to change { Video.count }.by(1)
  end

  it "#factory_creat_video_news_success" do
    expect {
      FactoryGirl.create :video_news
    }.to change { Video.count }.by(1)
  end

  it "#ivod_update_vod_work" do
    committee = FactoryGirl.create(:committee, :name => '內政委員會')
    legislator = FactoryGirl.create(:legislator, :name => '陳節如')
    video = FactoryGirl.build(:video_ivod)
    video.ivod_url = 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    video.update_ivod_values
    #raise video.inspect
    expect(video.date).to eq(Date.parse('2014-10-08'))
    expect(video.committee).to eq(committee)
    expect(video.legislators).to include(legislator)
    expect(video.meeting_description).to match("一、審查104年度中央政府總預算案關於內政部主管收支部分。")
  end

  it "#ivod_update_full_work" do
    committee = FactoryGirl.create(:committee, :name => '社會福利及衛生環境委員會')
    video = FactoryGirl.build(:video_ivod)
    video.ivod_url = 'http://ivod.ly.gov.tw/Play/Full/7648/300K'
    video.update_ivod_values
    #raise video.inspect
    expect(video.date).to eq(Date.parse('2014-04-10'))
    expect(video.committee).to eq(committee)
    expect(video.meeting_description).to match("立法院第8屆第5會期社會福利及衛生環境委員會第13次全體委員會議")
  end

  it "#youtube_update_work" do
    video = FactoryGirl.build(:video_news)
    video.youtube_url = 'https://www.youtube.com/watch?v=Gh1zJVwHhjw'
    video.update_youtube_values
    expect(video.image).to eq("https://i.ytimg.com/vi/Gh1zJVwHhjw/maxresdefault.jpg")
  end

  it "order created_at desc work" do
    video1 = FactoryGirl.create(:video_news, created_at: 1.day.ago)
    video2 = FactoryGirl.create(:video_news, created_at: Time.now)
    expect(Video.all).to eq([video2, video1])
  end

  it "published work" do
    video1 = FactoryGirl.create(:video_news)
    video2 = FactoryGirl.create(:video_news, published: false)
    expect(Video.published).to eq([video1])
  end

  it "created_in_time_count created_after work" do
    video1 = FactoryGirl.create(:video_news, created_at: Time.now)
    video2 = FactoryGirl.create(:video_news, created_at: 2.month.ago)
    video3 = FactoryGirl.create(:video_news, created_at: 4.months.ago)
    expect(Video.created_in_time_count(5.months.ago, 4.months)).to eq(2)
    expect(Video.created_after(3.months.ago)).to eq([video1, video2])
  end

  it "validate has_at_least_one_legislator work" do
    video = FactoryGirl.build(:video_news)
    video.legislators = []
    expect{video.save!}.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: 必須加入至少一名立法委員！')
  end

  it "validate is_source_url work" do
    video = FactoryGirl.build(:video_ivod)
    video.ivod_url = "wrong ivod url"
    expect{video.save!}.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: ivod網址錯誤')
    video.ivod_url = "http://ivod.ly.gov.tw/Play/VOD/300K"
    video.save
    expect(video.errors.messages[:base].first).to eq('ivod網址出錯')
    expect(video.ivod_url).to eq(nil)
  end
end