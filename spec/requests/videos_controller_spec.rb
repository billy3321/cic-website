require "spec_helper"

describe "Video" do


  let(:video) { FactoryGirl.create(:video) }
  let(:new_video) do
    {
      :title => "new_video_title",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :ivod_url => 'http://ivod.ly.gov.tw/Play/VOD/77018/300K',
      :youtube_url => 'https://www.youtube.com/watch?v=6tg_I9O-dV0'
    }
  end

  describe "#index" do
    it "success" do
      get "/videos/"
      response.should be_success
    end
  end

  describe "#show" do
    it "success" do
      get "/videos/#{video.id}"
      response.should be_success
    end
  end

  describe "#new" do
    it "success" do
      get "/videos/new"
      response.should be_success
    end
  end

  describe "#edit" do
    it "success" do
      get "/videos/#{video.id}/edit"
      response.should be_success
    end
  end

  describe "#create" do
    it "success" do
      expect {
        post "/videos", :video => new_video
      }.to change { Video.count }.by(1)
      response.should be_redirect
    end
  end

  describe "#update" do
    it "success" do
      video
      update_data = { :title => "new_title" }
      put "/videos/#{video.id}", :video => update_data
      response.should be_redirect
      video.reload
      expect(video.title).to match(update_data[:title])
    end
  end

  describe "#destroy" do
    it "success" do
      video
      expect {
        delete "/videos/#{video.id}"
      }.to change { Video.count }.by(-1)
      response.should be_redirect
    end
  end

end