require "spec_helper"

describe "Entry" do


  let(:entry) { FactoryGirl.create(:entry) }
  let(:new_entry) do
    {
      :title => "new_entry_title",
    }
  end

  describe "#index" do
    it "success" do
      get "/entries/"
      expect(response).to be_success
    end
  end

  describe "#show" do
    it "success" do
      get "/entries/#{entry.id}"
      expect(response).to be_success
    end
  end

  describe "#new" do
    it "success" do
      get "/entries/new"
      expect(response).to be_success
    end
  end

  describe "#edit" do
    it "success" do
      get "/entries/#{entry.id}/edit"
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "success" do
      expect {
        post "/entries", :entry => new_entry
      }.to change { Entry.count }.by(1)
      expect(response).to be_redirect
    end
  end

  describe "#update" do
    it "success" do
      entry
      update_data = { :title => "new_title" }
      put "/entries/#{entry.id}", :entry => update_data
      expect(response).to be_redirect
      entry.reload
      expect(entry.name).to match(update_data[:title])
    end
  end

  describe "#destroy" do
    it "success" do
      entry
      expect {
        delete "/entries/#{entry.id}"
      }.to change { Entry.count }.by(-1)
      expect(response).to be_redirect
    end
  end

end