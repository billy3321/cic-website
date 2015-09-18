require "rails_helper"

describe "Video" do

  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:video) { FactoryGirl.create(:video_news, user: user) }
  let(:new_video) do
    {
      :title => "new_video_title",
      :legislator_ids => [ FactoryGirl.create(:legislator).id ],
      :ivod_url => 'http://ivod.ly.gov.tw/Play/VOD/77018/300K',
      :youtube_url => 'https://www.youtube.com/watch?v=6tg_I9O-dV0',
      :video_type => 'news',
      :source_url => "http://www.google.com",
      :date => Date.today,
      :source_name => 'Google'
    }
  end

  describe "before login" do
    describe "#index with nothing" do
      it "success" do
        get "/videos/"
        expect(response).to be_success
      end
    end

    describe "#index" do
      it "success" do
        2.times { FactoryGirl.create(:video_news) }
        get "/videos/"
        expect(response).to be_success
      end
    end

    describe "#show" do
      it "success" do
        get "/videos/#{video.id}"
        expect(response).to be_success
      end
    end

    describe "#show unpublished" do
      it "failed" do
        video
        video.published = false
        video.save
        expect{
          get "/videos/#{video.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#new" do
      it "redirect" do
        get "/videos/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/videos/#{video.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/videos", :video => new_video
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        video
        update_data = { :title => "new_title" }
        put "/videos/#{video.id}", :video => update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        video
        expect {
          delete "/videos/#{video.id}"
        }.to change { Video.count }.by(0)
        expect(response).to be_redirect
      end
    end
  end
  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#show unpublished" do
      it "failed" do
        video
        video.published = false
        video.save
        expect{
          get "/videos/#{video.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#new" do
      it "success" do
        get "/videos/new"
        expect(response).to be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/videos/#{video.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#edit unpublished" do
      it "failed" do
        video
        video.published = false
        video.save
        expect{
          get "/videos/#{video.id}/edit"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#create" do
      it "success" do
        new_video[:user_id] = user.id
        expect {
          post "/videos", :video => new_video
        }.to change { Video.count }.by(1)
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "success" do
        video
        update_data = { :title => "new_title" }
        put "/videos/#{video.id}", :video => update_data
        expect(response).to be_redirect
        video.reload
        expect(video.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "failed" do
        video
        video.published = false
        video.save
        update_data = { :published => true }
        put "/videos/#{video.id}", :video => update_data
        expect(response).to be_redirect
        video.reload
        expect(video.published).to eq(false)
      end
    end

    describe "#destroy" do
      it "success" do
        video
        expect {
          delete "/videos/#{video.id}"
        }.to change { Video.count }.by(-1)
        expect(response).to be_redirect
      end
    end
  end

  describe "after login another user" do
    before { sign_in(another_user) }
    after { sign_out }

    describe "#edit" do
      it "redirect" do
        get "/videos/#{video.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "failed" do
        video
        update_data = { :title => "new_title" }
        put "/videos/#{video.id}", :video => update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "failed" do
        video
        delete "/videos/#{video.id}"
        expect(response).to be_redirect
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#show unpublished" do
      it "success" do
        video.published = false
        video.save
        get "/videos/#{video.id}"
        expect(response).to be_success
      end
    end

    describe "#edit unpublished" do
      it "success" do
        video.published = false
        video.save
        get "/videos/#{video.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#new" do
      it "success" do
        get "/videos/new"
        expect(response).to be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/videos/#{video.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#create" do
      it "success" do
        new_video[:user_id] = admin.id
        expect {
          post "/videos", :video => new_video
        }.to change { Video.count }.by(1)
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "success" do
        video
        update_data = { :title => "new_title" }
        put "/videos/#{video.id}", :video => update_data
        expect(response).to be_redirect
        video.reload
        expect(video.title).to match(update_data[:title])
      end
    end

    describe "#update unpublished" do
      it "success" do
        video
        video.published = false
        video.save
        update_data = { :published => true }
        put "/videos/#{video.id}", :video => update_data
        expect(response).to be_redirect
        video.reload
        expect(video.published).to eq(true)
      end
    end

    describe "#destroy" do
      it "success" do
        video
        expect {
          delete "/videos/#{video.id}"
        }.to change { Video.count }.by(-1)
        expect(response).to be_redirect
      end
    end
  end
end