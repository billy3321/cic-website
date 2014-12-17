require "spec_helper"

describe Question do
  let(:question) {FactoryGirl.create(:question)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :question
    }.to change { Question.count }.by(1)
  end

  it "#ivod_update_vod_work" do
    FactoryGirl.create(:committee, :name => '內政委員會')
    FactoryGirl.create(:legislator, :name => '陳節如')
    q = Question.new()
    q.ivod_url = 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    q.update_ivod_values
    expect(q.date).to eq(Date.parse('2014-10-08'))
    expect(q.committee.name).to eq('內政委員會')
    expect(q.legislators.first.name).to eq('陳節如')
  end

  it "#ivod_update_full_work" do
    FactoryGirl.create(:committee, :name => '社會福利及衛生環境委員會')
    q = Question.new()
    q.ivod_url = 'http://ivod.ly.gov.tw/Play/Full/7648/300K'
    q.update_ivod_values
    #raise v.inspect
    expect(q.date).to eq(Date.parse('2014-04-10'))
    expect(q.committee.name).to eq('社會福利及衛生環境委員會')
  end

end
