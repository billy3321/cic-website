require "spec_helper"

describe "Static pages" do

  describe "#home" do
    it "success" do
      get "/"
      response.should be_success
    end
  end

  describe "#recent" do
    it "success" do
      get "/recent"
      response.should be_success
    end
  end

  describe "#report" do
    it "success" do
      get "/report"
      response.should be_success
    end
  end

end
