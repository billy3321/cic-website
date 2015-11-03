object @committee
child(:@ad_session) do
  attributes :id, :name, :date_start, :date_end, :session, :regular
  child(:ad) do
    attributes :id, :name, :vote_date, :term_start, :term_end
  end
end
child(:@ccw_committee_datum => :committee) do
  child(:committee) do
    attributes id: :id
    attributes name: :name
  end
  attributes :should_attendance, :actually_average_attendance
  node(:avaliable_interpellation_count, if: ->(c) { @committee.kind == 'sc' }) do |c|
    c.avaliable_interpellation_count
  end
  node(:actually_average_interpellation_count, if: ->(c) { @committee.kind == 'sc' }) do |c|
    c.actually_average_interpellation_count
  end
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
  node(:attendance, if: ->(c) { @committee.kind == 'yc' }) do |c|
    c.yc_attendance
  end
  node(:attendance, if: ->(c) { @committee.kind == 'sc' }) do |c|
    c.sc_attendance
  end
  node(:interpellation_count, if: ->(c) { @committee.kind == 'sc' }) do |c|
    c.sc_interpellation_count
  end
end
node(:status) {"success"}