require "rails_helper"

describe "Static pages" do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe "before login" do
    describe "#home with nothing" do
      it "success" do
        get "/"
        expect(response).to be_success
      end
    end

    describe "#home" do
      it "success" do
        3.times { FactoryGirl.create :entry }
        3.times { FactoryGirl.create :question }
        3.times { FactoryGirl.create :video_news }
        get "/"
        expect(response).to be_success
      end
    end

    describe "#recent with nothing" do
      it "success" do
        get "/recent"
        expect(response).to be_success
      end
    end

    describe "#recent" do
      it "success" do
        3.times { FactoryGirl.create :entry }
        3.times { FactoryGirl.create :question }
        3.times { FactoryGirl.create :video_news }
        get "/recent"
        expect(response).to be_success
      end
    end

    describe "#report" do
      it "success" do
        get "/report"
        expect(response).to be_redirect
      end
    end

    describe "#about" do
      it "success" do
        get "/about"
        expect(response).to be_redirect
      end
    end
  end
  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#home has logout" do
      it "success" do
        get "/"
        expect(response.body).to match("登出")
        expect(response.body).to match("回報立委資訊")
      end
    end

    describe "#report" do
      it "success" do
        get "/report"
        expect(response).to be_success
      end
    end
  end

  describe "after admin login" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#home has logout" do
      it "success" do
        get "/"
        expect(response.body).to match("登出")
        expect(response.body).to match("回報立委資訊")
        expect(response.body).to match("後台首頁")
      end
    end
  end
end
