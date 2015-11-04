object @video
child(:@video) do
  child(:legislators) do
    attributes :id, :name, :image
    child(:party) do
      attributes :id, :name, :abbreviation
      node :image do |p|
        "#{Setting.url.protocol}://#{Setting.url.host}/images/parties/#{p.image}"
      end
    end
  end
  child(:ad_session) do
    attributes :id, :name, :date_start, :date_end, :session, :regular
    child(:ad) do
      attributes :id, :name, :vote_date, :term_start, :term_end
    end
  end
  child(:committee) do
    attributes id: :id
    attributes name: :name
  end
  attributes :id, :title, :content, :video_type, :meeting_description, :youtube_url, :youtube_id
  attributes :image, :source_url, :source_name, :time_start, :time_end, :date, :target, :created_at, :updated_at
end
node(:status) {"success"}