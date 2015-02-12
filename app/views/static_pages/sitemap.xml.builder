base_url = "https://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
 
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
 
  xml.url do
    xml.loc "#{base_url}"
    xml.changefreq "monthly"
    xml.priority 1.0
  end
 
  xml.url do
    xml.loc "#{base_url}/faq"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/recent"
    xml.lastmod Time.now.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/legislators"
    xml.lastmod Time.now.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/legislators/no_record"
    xml.lastmod Time.now.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/legislators/has_records"
    xml.lastmod Time.now.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/videos"
    xml.lastmod Time.now.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/entries"
    xml.lastmod Time.now.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/questions"
    xml.lastmod Time.now.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end
 
  xml.url do
    xml.loc "#{base_url}/privacy"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/service"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/tutorial"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 1.0
  end
 
  xml.url do
    xml.loc "#{base_url}/about"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 1.0
  end
 
  @legislators.each do |legislator|
    xml.url do
      xml.loc legislator_url(legislator)
      xml.priority 0.9
    end

    xml.url do
      xml.loc entries_legislator_url(legislator)
      xml.priority 0.9
    end

    xml.url do
      xml.loc questions_legislator_url(legislator)
      xml.priority 0.9
    end

    xml.url do
      xml.loc videos_legislator_url(legislator)
      xml.priority 0.9
    end
  end
 
  @entries.each do |entry|
    xml.url do
      xml.loc entry_url(entry)
      xml.lastmod entry.updated_at.to_date
      xml.changefreq "always"
      xml.priority 0.9
    end
  end

  @questions.each do |question|
    xml.url do
      xml.loc question_url(question)
      xml.lastmod question.updated_at.to_date
      xml.changefreq "always"
      xml.priority 0.9
    end
  end

  @videos.each do |video|
    xml.url do
      xml.loc video_url(video)
      xml.lastmod video.updated_at.to_date
      xml.changefreq "always"
      xml.priority 0.9
    end
  end
 
end