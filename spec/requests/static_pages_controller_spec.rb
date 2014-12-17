require "spec_helper"

describe "Static pages" do

  describe "#home" do
    it "success" do
      get "/"
      expect(response).to be_success
    end
  end

  describe "#recent" do
    it "success" do
      get "/recent"
      expect(response).to be_success
    end
  end

end
