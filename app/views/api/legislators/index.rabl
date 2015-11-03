object @legislators
node(:count) { |_| @legislators_count }
child(:@legislators) do
  attributes :id, :name, :image, :party, :in_office
  attributes :fb_link, :wiki_link, :musou_link, :ccw_link, :ivod_link
  node :image do |l|
    "#{Setting.url.protocol}://#{Setting.url.host}/images/legislators/160x214/#{l.image}"
  end
  child(:party) do
    attributes :name, :abbreviation
    node :image do |p|
      "#{Setting.url.protocol}://#{Setting.url.host}/images/parties/#{p.image}"
    end
  end
  child(:elections) do
    attributes :constituency
    child(:party) do
      attributes :id, :name, :abbreviation
      node :image do |p|
        "#{Setting.url.protocol}://#{Setting.url.host}/images/parties/#{p.image}"
      end
    end
    child(:ad) do
      attributes :id, :name, :vote_date, :term_start, :term_end
    end
  end
  child(legislator_committees: :committees) do
    glue(:committee) do
      attributes id: :id
      attributes name: :name
    end
    attributes :convener
    child(:ad_session) do
      attributes :id, :name, :session, :regular, :date_start, :date_end, :session, :regular
      child(:ad) do
        attributes :id, :name, :vote_date, :term_start, :term_end
      end
    end
  end
end
node(:status) {"success"}
