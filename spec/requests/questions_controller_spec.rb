require "rails_helper"

describe "Question" do

  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:question) { FactoryGirl.create(:question, user: user) }
  let(:committee) { FactoryGirl.create(:committee, name: "內政委員會") }
  let(:new_question) do
    {
      :title => "new_question_title",
      :content => "new_question_content",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :ivod_url => 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    }
  end

  describe "before login" do
    describe "#index with nothing" do
      it "success" do
        get "/questions/"
        expect(response).to be_success
      end
    end

    describe "#show" do
      it "success" do
        2.times { FactoryGirl.create(:question) }
        get "/questions/#{question.id}"
        expect(response).to be_success
      end
    end

    describe "#show unpublished" do
      it "failed" do
        question
        question.published = false
        question.save
        expect{
          get "/questions/#{question.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#new" do
      it "redirect" do
        get "/questions/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/questions/#{question.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/questions", :question => new_question
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        question
        update_data = { :title => "new_title" }
        put "/questions/#{question.id}", :question => update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        question
        expect {
          delete "/questions/#{question.id}"
        }.to change { Question.count }.by(0)
        expect(response).to be_redirect
      end
    end
  end
  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#show unpublished" do
      it "failed" do
        question
        question.published = false
        question.save
        expect{
          get "/questions/#{question.id}"
        }.to raise_error(ActionController::RoutingError)
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

    describe "#edit unpublished" do
      it "failed" do
        question
        question.published = false
        question.save
        expect{
          get "/questions/#{question.id}/edit"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#create" do
      it "success" do
        new_question[:user_id] = user.id
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
        expect(question.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "failed" do
        question
        question.published = false
        question.save
        update_data = { :published => true }
        put "/questions/#{question.id}", :question => update_data
        expect(response).to be_redirect
        question.reload
        expect(question.published).to eq(false)
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

  describe "after login another user" do
    before { sign_in(another_user) }
    after { sign_out }

    describe "#edit" do
      it "redirect" do
        get "/questions/#{question.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "failed" do
        question
        update_data = { :title => "new_title" }
        put "/questions/#{question.id}", :question => update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "failed" do
        question
        delete "/questions/#{question.id}"
        expect(response).to be_redirect
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#show unpublished" do
      it "success" do
        question.published = false
        question.save
        get "/questions/#{question.id}"
        expect(response).to be_success
      end
    end

    describe "#edit unpublished" do
      it "success" do
        question.published = false
        question.save
        get "/questions/#{question.id}/edit"
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
        new_question[:user_id] = admin.id
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
        expect(question.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "success" do
        question
        question.published = false
        question.save
        update_data = { :published => true }
        put "/questions/#{question.id}", :question => update_data
        expect(response).to be_redirect
        question.reload
        expect(question.published).to eq(true)
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
end