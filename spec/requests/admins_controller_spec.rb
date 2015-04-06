require "rails_helper"

describe "Admin" do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:new_admin) do
    {
      :title => "new_admin_title",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :ivod_url => 'http://ivod.ly.gov.tw/Play/VOD/77018/300K'
    }
  end

  describe "before login" do
    it "redirect" do
      get "/admin/"
      expect(response).to be_redirect
    end
  end

  describe "login as user" do
    before { sign_in(user) }
    after { sign_out }

    it "redirect" do
      get "/admin"
      expect(response).to be_redirect
    end
  end

  describe "login as admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#index" do
      it "success" do
        get "/admin/"
        expect(response).to be_success
      end
    end

    describe "#data" do
      it "success" do
        get "/admin/data"
        expect(response).to be_success
      end
    end

    describe "#entries" do
      it "success" do
        get "/admin/entries"
        expect(response).to be_success
      end
    end

    describe "#interpellations" do
      it "success" do
        get "/admin/interpellations"
        expect(response).to be_success
      end
    end

    describe "#videos" do
      it "success" do
        get "/admin/videos"
        expect(response).to be_success
      end
    end

    describe "#update_interpellations" do
      it "success" do
        interpellation1 = FactoryGirl.create :interpellation
        interpellation2 = FactoryGirl.create :interpellation
        interpellation3 = FactoryGirl.create :interpellation
        update_data = {
          interpellation_ids: [interpellation1.id, interpellation2.id, interpellation3.id],
          unpublished_ids: [interpellation1.id, interpellation3.id]
        }
        put "/admin/update_interpellations", update_data
        expect(response).to be_redirect
        expect(Interpellation.published).to eq([interpellation2])
      end
    end

    describe "#update_videos" do
      it "success" do
        video1 = FactoryGirl.create :video_news
        video2 = FactoryGirl.create :video_news
        video3 = FactoryGirl.create :video_ivod
        update_data = {
          video_ids: [video1.id, video2.id, video3.id],
          unpublished_ids: [video1.id, video3.id]
        }
        put "/admin/update_videos", update_data
        expect(response).to be_redirect
        expect(Video.published).to eq([video2])
      end
    end

    describe "#update_entries" do
      it "success" do
        entry1 = FactoryGirl.create :entry
        entry2 = FactoryGirl.create :entry
        entry3 = FactoryGirl.create :entry
        update_data = {
          entry_ids: [entry1.id, entry2.id, entry3.id],
          unpublished_ids: [entry1.id, entry3.id]
        }
        put "/admin/update_entries", update_data
        expect(response).to be_redirect
        expect(Entry.published).to eq([entry2])
      end
    end
  end
end