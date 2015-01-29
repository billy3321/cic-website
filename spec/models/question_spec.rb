require "rails_helper"

describe Question do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :question
    }.to change { Question.count }.by(1)
  end

  it "#ivod_update_vod_work" do
    committee = FactoryGirl.create(:committee, :name => '內政委員會')
    legislator = FactoryGirl.create(:legislator, :name => '陳節如')
    question = FactoryGirl.build :question
    question.ivod_url = 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    question.update_ivod_values
    expect(question.date).to eq(Date.parse('2014-10-08'))
    expect(question.committee).to eq(committee)
    expect(question.legislators).to include(legislator)
    expect(question.ivod_url).to eq('http://ivod.ly.gov.tw/Play/VOD/77018/1M')
  end

  it "#ivod_update_full_work" do
    committee = FactoryGirl.create(:committee, :name => '社會福利及衛生環境委員會')
    question = FactoryGirl.build :question
    question.ivod_url = 'http://ivod.ly.gov.tw/Play/Full/7648/300K'
    question.update_ivod_values
    #raise v.inspect
    expect(question.date).to eq(Date.parse('2014-04-10'))
    expect(question.committee).to eq(committee)
    expect(question.ivod_url).to eq('http://ivod.ly.gov.tw/Play/Full/7648/1M')
    expect(question.meeting_description).to match("立法院第8屆第5會期社會福利及衛生環境委員會第13次全體委員會議")
  end

  it "order created_at desc work" do
    question1 = FactoryGirl.create(:question, created_at: 1.day.ago)
    question2 = FactoryGirl.create(:question, created_at: Time.now)
    expect(Question.all).to eq([question2, question1])
  end

  it "published work" do
    question1 = FactoryGirl.create(:question)
    question2 = FactoryGirl.create(:question, published: false)
    expect(Question.published).to eq([question1])
  end

  it "created_in_time_count created_after work" do
    question1 = FactoryGirl.create(:question, created_at: Time.now)
    question2 = FactoryGirl.create(:question, created_at: 2.month.ago)
    question3 = FactoryGirl.create(:question, created_at: 4.months.ago)
    expect(Question.created_in_time_count(5.months.ago, 4.months)).to eq(2)
    expect(Question.created_after(3.months.ago)).to eq([question1, question2])
  end

  it "validate has_at_least_one_legislator work" do
    question = FactoryGirl.build(:question)
    question.legislators = []
    expect{question.save!}.to raise_error(ActiveRecord::RecordInvalid,'校驗失敗: 必須填寫立委姓名！')
  end

  it "validate is_source_url work" do
    question = FactoryGirl.build(:question)
    question.ivod_url = "wrong ivod url"
    expect{question.save!}.to raise_error(ActiveRecord::RecordInvalid,'校驗失敗: ivod網址錯誤')
    question.ivod_url = "http://ivod.ly.gov.tw/Play/VOD/300K"
    question.save
    expect(question.errors.messages[:base].first).to eq('ivod網址出錯')
    expect(question.ivod_url).to eq(nil)
  end

end
