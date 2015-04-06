require "rails_helper"

describe "Interpellation" do

  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:interpellation) { FactoryGirl.create(:interpellation, user: user) }
  let(:committee) { FactoryGirl.create(:committee, name: "內政委員會") }
  let(:new_interpellation) do
    {
      :title => "new_interpellation_title",
      :content => "new_interpellation_content",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :ivod_url => 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    }
  end

  describe "before login" do
    describe "#index with nothing" do
      it "success" do
        get "/interpellations/"
        expect(response).to be_success
      end
    end

    describe "#show" do
      it "success" do
        2.times { FactoryGirl.create(:interpellation) }
        get "/interpellations/#{interpellation.id}"
        expect(response).to be_success
      end
    end

    describe "#show unpublished" do
      it "failed" do
        interpellation
        interpellation.published = false
        interpellation.save
        expect{
          get "/interpellations/#{interpellation.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#new" do
      it "redirect" do
        get "/interpellations/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/interpellations/#{interpellation.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/interpellations", :interpellation => new_interpellation
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        interpellation
        update_data = { :title => "new_title" }
        put "/interpellations/#{interpellation.id}", :interpellation => update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        interpellation
        expect {
          delete "/interpellations/#{interpellation.id}"
        }.to change { Interpellation.count }.by(0)
        expect(response).to be_redirect
      end
    end
  end
  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#show unpublished" do
      it "failed" do
        interpellation
        interpellation.published = false
        interpellation.save
        expect{
          get "/interpellations/#{interpellation.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#new" do
      it "success" do
        get "/interpellations/new"
        expect(response).to be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/interpellations/#{interpellation.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#edit unpublished" do
      it "failed" do
        interpellation
        interpellation.published = false
        interpellation.save
        expect{
          get "/interpellations/#{interpellation.id}/edit"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#create" do
      it "success" do
        new_interpellation[:user_id] = user.id
        expect {
          post "/interpellations", :interpellation => new_interpellation
        }.to change { Interpellation.count }.by(1)
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "success" do
        interpellation
        update_data = { :title => "new_title" }
        put "/interpellations/#{interpellation.id}", :interpellation => update_data
        expect(response).to be_redirect
        interpellation.reload
        expect(interpellation.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "failed" do
        interpellation
        interpellation.published = false
        interpellation.save
        update_data = { :published => true }
        put "/interpellations/#{interpellation.id}", :interpellation => update_data
        expect(response).to be_redirect
        interpellation.reload
        expect(interpellation.published).to eq(false)
      end
    end

    describe "#destroy" do
      it "success" do
        interpellation
        expect {
          delete "/interpellations/#{interpellation.id}"
        }.to change { Interpellation.count }.by(-1)
        expect(response).to be_redirect
      end
    end
  end

  describe "after login another user" do
    before { sign_in(another_user) }
    after { sign_out }

    describe "#edit" do
      it "redirect" do
        get "/interpellations/#{interpellation.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "failed" do
        interpellation
        update_data = { :title => "new_title" }
        put "/interpellations/#{interpellation.id}", :interpellation => update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "failed" do
        interpellation
        delete "/interpellations/#{interpellation.id}"
        expect(response).to be_redirect
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#show unpublished" do
      it "success" do
        interpellation.published = false
        interpellation.save
        get "/interpellations/#{interpellation.id}"
        expect(response).to be_success
      end
    end

    describe "#edit unpublished" do
      it "success" do
        interpellation.published = false
        interpellation.save
        get "/interpellations/#{interpellation.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#new" do
      it "success" do
        get "/interpellations/new"
        expect(response).to be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/interpellations/#{interpellation.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#create" do
      it "success" do
        new_interpellation[:user_id] = admin.id
        expect {
          post "/interpellations", :interpellation => new_interpellation
        }.to change { Interpellation.count }.by(1)
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "success" do
        interpellation
        update_data = { :title => "new_title" }
        put "/interpellations/#{interpellation.id}", :interpellation => update_data
        expect(response).to be_redirect
        interpellation.reload
        expect(interpellation.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "success" do
        interpellation
        interpellation.published = false
        interpellation.save
        update_data = { :published => true }
        put "/interpellations/#{interpellation.id}", :interpellation => update_data
        expect(response).to be_redirect
        interpellation.reload
        expect(interpellation.published).to eq(true)
      end
    end

    describe "#destroy" do
      it "success" do
        interpellation
        expect {
          delete "/interpellations/#{interpellation.id}"
        }.to change { Interpellation.count }.by(-1)
        expect(response).to be_redirect
      end
    end
  end
end