require "spec_helper"

describe "Question" do


  let(:user) { FactoryGirl.create(:admin) }
  let(:new_admin) do
    {
      :title => "new_admin_title",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :ivod_url => 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    }
  end

  describe "#index" do
    it "success" do
      get "/admin/"
      response.should be_success
    end
  end

  describe "#data" do
    it "success" do
      get "/admin/data"
      response.should be_success
    end
  end

  describe "#entries" do
    it "success" do
      get "/admin/entries"
      response.should be_success
    end
  end

  describe "#questions" do
    it "success" do
      get "/admin/questions"
      response.should be_success
    end
  end

  describe "#videos" do
    it "success" do
      get "/admin/videos"
      response.should be_success
    end
  end

  describe "#create" do
    it "success" do
      expect {
        post "/admin", :admin => new_admin
      }.to change { Question.count }.by(1)
      response.should be_redirect
    end
  end

  describe "#update" do
    it "success" do
      admin
      update_data = { :title => "new_title" }
      put "/admin/#{admin.id}", :admin => update_data
      response.should be_redirect
      admin.reload
      expect(admin.title).to match(update_data[:title])
    end
  end

  describe "#destroy" do
    it "success" do
      admin
      expect {
        delete "/admin/#{admin.id}"
      }.to change { Question.count }.by(-1)
      response.should be_redirect
    end
  end

end