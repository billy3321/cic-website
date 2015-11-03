object @entry
child(:@entry) do
  child(:legislators) do
    attributes :id, :name, :image
    child(:party) do
      attributes :id, :name, :abbreviation
      node :image do |p|
        "#{Setting.url.protocol}://#{Setting.url.host}/images/parties/#{p.image}"
      end
    end
  end
  attributes :title, :content, :source_url, :source_name, :date, :created_at, :updated_at
end
node(:status) {"success"}