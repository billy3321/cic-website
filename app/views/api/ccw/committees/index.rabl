object @committees
child(:@ad_session) do
  attributes :id, :name, :date_start, :date_end, :session, :regular
  child(:ad) do
    attributes :id, :name, :vote_date, :term_start, :term_end
  end
end
child(:@ccw_committee_data => :committees) do
  child(:committee) do
    attributes :id, :name
  end
  attributes :should_attendance, :actually_average_attendance
  attributes :avaliable_interpellation_count, :actually_average_interpellation_count
end
node(:status) {"success"}