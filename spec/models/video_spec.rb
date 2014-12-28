require "spec_helper"

describe Video do
  let(:video) {FactoryGirl.create(:video_news)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :video_news
    }.to change { Video.count }.by(1)
  end

  it "#ivod_update_vod_work" do
    FactoryGirl.create(:committee, :name => '內政委員會')
    FactoryGirl.create(:legislator, :name => '陳節如')
    v = FactoryGirl.build(:vidoe_ivod)
    v.ivod_url = 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    v.update_ivod_values
    #raise v.inspect
    expect(v.date).to eq(Date.parse('2014-10-08'))
    expect(v.committee.name).to eq('內政委員會')
    expect(v.legislators.first.name).to eq('陳節如')
  end

  it "#ivod_update_full_work" do
    FactoryGirl.create(:committee, :name => '社會福利及衛生環境委員會')
    v = FactoryGirl.build(:vidoe_ivod)
    v.ivod_url = 'http://ivod.ly.gov.tw/Play/Full/7648/300K'
    v.update_ivod_values
    #raise v.inspect
    expect(v.date).to eq(Date.parse('2014-04-10'))
    expect(v.committee.name).to eq('社會福利及衛生環境委員會')
  end

  it "#youtube_update_work" do
    v = FactoryGirl.build(:vidoe_news)
    v.youtube_url = 'https://www.youtube.com/watch?v=Gh1zJVwHhjw'
    v.update_youtube_values
    expect(v.image).to eq("https://i.ytimg.com/vi/Gh1zJVwHhjw/maxresdefault.jpg")
    expect(v.title).to eq("陳淳杰／發光的靈魂   ～《牽阮的手》插曲")
  end
end