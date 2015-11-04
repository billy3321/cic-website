object @ad_sessions
node(:count) { |_| @ad_sessions_count }
child(:@ad_sessions) do
  attributes :id, :name, :date_start, :date_end, :session, :regular
  child(:ad) do
    attributes :id, :name, :vote_date, :term_start, :term_end
  end
end
node(:status) {"success"}