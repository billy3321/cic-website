require "spec_helper"

describe "Legislator" do


  let(:legislator) { FactoryGirl.create(:legislator) }

  describe "#index" do
    it "success" do
      get "/legislators/"
      expect(response).to be_success
    end
  end

  describe "#show" do
    it "success" do
      get "/legislators/#{legislator.id}"
      expect(response).to be_success
    end
  end

end