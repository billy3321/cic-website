object @legislator
child(:@ad_session) do
  attributes :id, :name, :date_start, :date_end, :session, :regular
  child(:ad) do
    attributes :id, :name, :vote_date, :term_start, :term_end
  end
end
child(:@ccw_legislator_datum => :legislator) do
  glue(:legislator) do
    attributes :id, :name, :image
    child(:party) do
      attributes :id, :name, :abbreviation
      node :image do |p|
        "#{Setting.url.protocol}://#{Setting.url.host}/images/parties/#{p.image}"
      end
    end
  end
  attributes :yc_attendance, :sc_attendance, :sc_interpellation_count
  attributes :first_proposal_count, :not_first_proposal_count, :budgetary_count, :auditing_count
  attributes :citizen_score, :new_sunshine_bills, :modify_sunshine_bills
  attributes :budgetary_deletion_passed, :budgetary_deletion_impact, :budgetary_deletion_special
  attributes :special, :conflict_expose, :allow_visitor, :human_rights_infringing_bill, :human_rights_infringing_budgetary
  attributes :judicial_case, :disorder
end
child(:@sc_committee_datum => :sc_committee) do
  child(:committee) do
    attributes id: :id
    attributes name: :name
  end
  attributes :should_attendance, :actually_average_attendance
  attributes :avaliable_interpellation_count, :actually_average_interpellation_count
end
child(:@yc_committee_datum => :yc_committee) do
  child(:committee) do
    attributes id: :id
    attributes name: :name
  end
  attributes :should_attendance, :actually_average_attendance
end
child(:@ccw_citizen_score => :citizen_score) do
  attributes :total, :average
end
node(:status) {"success"}