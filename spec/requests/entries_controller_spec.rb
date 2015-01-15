require "rails_helper"

describe "Entry" do

  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:entry) { FactoryGirl.create(:entry, user: user) }
  let(:new_entry) do
    {
      :title => "new_entry_title",
      :content => "new_entry_content",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :source_url => "http://www.google.com/",
      :source_name => "new_entry_source_name",
      :date => Date.today
    }
  end

  describe "before login" do
    describe "#index with nothing" do
      it "success" do
        get "/entries/"
        response.should be_success
      end
    end

    describe "#index" do
      it "success" do
        2.times { FactoryGirl.create(:entry) }
        get "/entries/"
        response.should be_success
      end
    end

    describe "#show" do
      it "success" do
        get "/entries/#{entry.id}"
        response.should be_success
      end
    end

    describe "#show unpublished" do
      it "failed" do
        entry
        entry.published = false
        entry.save
        expect{
          get "/entries/#{entry.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#new" do
      it "redirect" do
        get "/entries/new"
        response.should be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/entries/#{entry.id}/edit"
        response.should be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/entries", :entry => new_entry
        response.should be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        entry
        update_data = { :title => "new_title" }
        put "/entries/#{entry.id}", :entry => update_data
        response.should be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        entry
        expect {
          delete "/entries/#{entry.id}"
        }.to change { Entry.count }.by(0)
        response.should be_redirect
      end
    end
  end
  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#show unpublished" do
      it "failed" do
        entry
        entry.published = false
        entry.save
        expect{
          get "/entries/#{entry.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#new" do
      it "success" do
        get "/entries/new"
        response.should be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/entries/#{entry.id}/edit"
        response.should be_success
      end
    end

    describe "#edit unpublished" do
      it "failed" do
        entry
        entry.published = false
        entry.save
        expect{
          get "/entries/#{entry.id}/edit"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#create" do
      it "success" do
        new_entry[:user_id] = user.id
        expect {
          post "/entries", :entry => new_entry
        }.to change { Entry.count }.by(1)
        response.should be_redirect
      end
    end

    describe "#update" do
      it "success" do
        entry
        update_data = { :title => "new_title" }
        put "/entries/#{entry.id}", :entry => update_data
        response.should be_redirect
        entry.reload
        expect(entry.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "failed" do
        entry
        entry.published = false
        entry.save
        update_data = { :published => true }
        put "/entries/#{entry.id}", :entry => update_data
        response.should be_redirect
        entry.reload
        expect(entry.published).to eq(false)
      end
    end

    describe "#destroy" do
      it "success" do
        entry
        expect {
          delete "/entries/#{entry.id}"
        }.to change { Entry.count }.by(-1)
        response.should be_redirect
      end
    end
  end

  describe "after login another user" do
    before { sign_in(another_user) }
    after { sign_out }

    describe "#edit" do
      it "redirect" do
        get "/entries/#{entry.id}/edit"
        response.should be_redirect
      end
    end

    describe "#update" do
      it "failed" do
        entry
        update_data = { :title => "new_title" }
        put "/entries/#{entry.id}", :entry => update_data
        response.should be_redirect
      end
    end

    describe "#destroy" do
      it "failed" do
        entry
        delete "/entries/#{entry.id}"
        response.should be_redirect
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#show unpublished" do
      it "success" do
        entry.published = false
        entry.save
        get "/entries/#{entry.id}"
        response.should be_success
      end
    end

    describe "#edit unpublished" do
      it "success" do
        entry.published = false
        entry.save
        get "/entries/#{entry.id}/edit"
        response.should be_success
      end
    end

    describe "#new" do
      it "success" do
        get "/entries/new"
        response.should be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/entries/#{entry.id}/edit"
        response.should be_success
      end
    end

    describe "#create" do
      it "success" do
        new_entry[:user_id] = admin.id
        expect {
          post "/entries", :entry => new_entry
        }.to change { Entry.count }.by(1)
        response.should be_redirect
      end
    end

    describe "#update" do
      it "success" do
        entry
        update_data = { :title => "new_title" }
        put "/entries/#{entry.id}", :entry => update_data
        response.should be_redirect
        entry.reload
        expect(entry.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "success" do
        entry
        entry.published = false
        entry.save
        update_data = { :published => true }
        put "/entries/#{entry.id}", :entry => update_data
        response.should be_redirect
        entry.reload
        expect(entry.published).to eq(true)
      end
    end

    describe "#destroy" do
      it "success" do
        entry
        expect {
          delete "/entries/#{entry.id}"
        }.to change { Entry.count }.by(-1)
        response.should be_redirect
      end
    end
  end
end