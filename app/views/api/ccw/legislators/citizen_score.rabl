object @ccw_citizen_score
node(:count) { |_| @ccw_legislator_data_count }
child(:@ad_session) do
  attributes :id, :name, :date_start, :date_end, :session, :regular
  child(:ad) do
    attributes :id, :name, :vote_date, :term_start, :term_end
  end
end
child(:@ccw_citizen_score => :citizen_score) do
  attributes :total, :average, :ccw_link
end
child(:@ccw_legislator_data => :legislators) do
  glue(:legislator) do
    attributes :id, :name, :image
    child(:party) do
      attributes :id, :name, :abbreviation
      node :image do |p|
        "#{Setting.url.protocol}://#{Setting.url.host}/images/parties/#{p.image}"
      end
    end
  end
  attributes :citizen_score
end
node(:status) {"success"}