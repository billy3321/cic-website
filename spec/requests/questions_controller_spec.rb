require "spec_helper"

describe "Question" do


  let(:question) { FactoryGirl.create(:question) }
  let(:new_question) do
    {
      :title => "new_question_title",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :ivod_url => 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    }
  end

  describe "#index" do
    it "success" do
      get "/questions/"
      response.should be_success
    end
  end

  describe "#show" do
    it "success" do
      get "/questions/#{question.id}"
      response.should be_success
    end
  end

  describe "#new" do
    it "success" do
      get "/questions/new"
      response.should be_success
    end
  end

  describe "#edit" do
    it "success" do
      get "/questions/#{question.id}/edit"
      response.should be_success
    end
  end

  describe "#create" do
    it "success" do
      puts Question.count
      post "/questions", :question => new_question
      puts response.body.inspect
      puts Question.count
      expect {
        post "/questions", :question => new_question
      }.to change { Question.count }.by(1)
      response.should be_redirect
    end
  end

  describe "#update" do
    it "success" do
      question
      update_data = { :title => "new_title" }
      put "/questions/#{question.id}", :question => update_data
      response.should be_redirect
      question.reload
      expect(question.title).to match(update_data[:title])
    end
  end

  describe "#destroy" do
    it "success" do
      question
      expect {
        delete "/questions/#{question.id}"
      }.to change { Question.count }.by(-1)
      response.should be_redirect
    end
  end

end