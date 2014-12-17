require "spec_helper"

describe "Question" do


  let(:question) { FactoryGirl.create(:question) }
  let(:new_question) do
    {
      :title => "new_question_title",
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
      get "/questions/new"
      expect(response).to be_success
    end
  end

  describe "#edit" do
    it "success" do
      get "/questions/#{question.id}/edit"
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "success" do
      expect {
        post "/questions", :question => new_question
      }.to change { Question.count }.by(1)
      expect(response).to be_redirect
    end
  end

  describe "#update" do
    it "success" do
      question
      update_data = { :title => "new_title" }
      put "/questions/#{question.id}", :question => update_data
      expect(response).to be_redirect
      question.reload
      expect(question.name).to match(update_data[:title])
    end
  end

  describe "#destroy" do
    it "success" do
      question
      expect {
        delete "/questions/#{question.id}"
      }.to change { Question.count }.by(-1)
      expect(response).to be_redirect
    end
  end

end