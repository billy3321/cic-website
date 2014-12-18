require "spec_helper"

describe "Entry" do


  let(:entry) { FactoryGirl.create(:entry) }
  let(:new_entry) do
    {
      :title => "new_entry_title",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ]
    }
  end

  describe "#index" do
    it "success" do
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