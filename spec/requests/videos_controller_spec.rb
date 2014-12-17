require "spec_helper"

describe "Video" do


  let(:video) { FactoryGirl.create(:video) }
  let(:new_video) do
    {
      :title => "new_video_title",
    }
  end

  describe "#index" do
    it "success" do
      get "/questions/"
      expect(response).to be_success
    end
  end

  describe "#show" do
    it "success" do
      get "/questions/#{question.id}"
      expect(response).to be_success
    end
  end

  describe "#new" do
    it "success" do
      get "/videos/new"
      expect(response).to be_success
    end
  end

  describe "#edit" do
    it "success" do
      get "/videos/#{video.id}/edit"
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "success" do
      expect {
        post "/videos", :video => new_video
      }.to change { Video.count }.by(1)
      expect(response).to be_redirect
    end
  end

  describe "#update" do
    it "success" do
      video
      update_data = { :title => "new_title" }
      put "/videos/#{video.id}", :video => update_data
      expect(response).to be_redirect
      video.reload
      expect(video.name).to match(update_data[:title])
    end
  end

  describe "#destroy" do
    it "success" do
      video
      expect {
        delete "/videos/#{video.id}"
      }.to change { Video.count }.by(-1)
      expect(response).to be_redirect
    end
  end

end