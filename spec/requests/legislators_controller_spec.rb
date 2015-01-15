require "spec_helper"

describe "Legislator" do

  let(:legislator) { FactoryGirl.create(:legislator) }

  describe "#index" do
    it "success" do
      get "/legislators/"
      response.should be_success
    end
  end

  describe "#show" do
    it "no_record success" do
      get "/legislators/#{legislator.id}"
      response.should be_success
    end

    it "has_records success" do
      FactoryGirl.create(:entry, legislators: [legislator])
      FactoryGirl.create(:question, legislators: [legislator])
      FactoryGirl.create(:video_news, legislators: [legislator])
      get "/legislators/#{legislator.id}"
      response.should be_success
    end
  end

  describe "#entries" do
    it "no_record success" do
      get "/legislators/#{legislator.id}/entries"
      response.should be_success
    end

    it "has_records success" do
      2.times do
        FactoryGirl.create(:entry, legislators: [legislator])
      end
      get "/legislators/#{legislator.id}/entries"
      response.should be_success
    end
  end

  describe "#questions" do
    it "no_record success" do
      get "/legislators/#{legislator.id}/questions"
      response.should be_success
    end

    it "has_records success" do
      2.times do
        FactoryGirl.create(:question, legislators: [legislator])
      end
      get "/legislators/#{legislator.id}/questions"
      response.should be_success
    end
  end

  describe "#videos" do
    it "no_record success" do
      get "/legislators/#{legislator.id}/videos"
      response.should be_success
    end

    it "has_records success" do
      2.times do
        FactoryGirl.create(:video_news, legislators: [legislator])
      end
      get "/legislators/#{legislator.id}/videos"
      response.should be_success
    end
  end

end