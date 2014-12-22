class Video < ActiveRecord::Base
  has_and_belongs_to_many :legislators, -> { uniq }
  has_and_belongs_to_many :keywords, -> { uniq }
  belongs_to :user
  belongs_to :committee
  belongs_to :ad_session
  validates_presence_of :youtube_url, :ivod_url
  validate :has_at_least_one_legislator
  validate :is_youtube_url, :is_ivod_url
  delegate :ad, :to => :ad_session, :allow_nil => true
  before_save :update_youtube_values, :update_ivod_values, :update_ad_session_values
  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }

  def update_youtube_values
    youtube_id = extract_youtube_id(self.youtube_url)
    if self.youtube_id == youtube_id
      # means that youtube is the same, no need to update.
      return nil
    end
    self.youtube_id = youtube_id
    self.youtube_url = "https://www.youtube.com/watch?v=" + self.youtube_id
    api_url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' + self.youtube_id + '&key=' + Setting.google_public_key.api_key
    response = HTTParty.get(api_url)
    result = JSON.parse(response.body)
    if result['items'][0]['snippet']['thumbnails'].key?('maxres')
      self.image = result['items'][0]['snippet']['thumbnails']['maxres']['url']
    elsif result['items'][0]['snippet']['thumbnails'].key?('standard')
      self.image = result['items'][0]['snippet']['thumbnails']['standard']['url']
    elsif result['items'][0]['snippet']['thumbnails'].key?('high')
      self.image = result['items'][0]['snippet']['thumbnails']['high']['url']
    elsif result['items'][0]['snippet']['thumbnails'].key?('medium')
      self.image = result['items'][0]['snippet']['thumbnails']['medium']['url']
    elsif result['items'][0]['snippet']['thumbnails'].key?('default')
      self.image = result['items'][0]['snippet']['thumbnails']['default']['url']
    else
      self.image = ''
    end

    if self.title.blank?
      self.title = result['items'][0]['snippet']['title']
    end
    if self.content.blank?
      self.content = result['items'][0]['snippet']['description'].gsub(/[\n]/,"<br />").gsub(/[\r]/,"")
    end
  end

  def update_ivod_values
    unless self.ivod_url
      return nil
    end
    ivod_uri = URI.parse(self.ivod_url)
    html = Nokogiri::HTML(open(self.ivod_url))
    info_section = html.css('div.movie_box div.text')[0]
    unless info_section
      # the ivod url is error
      self.ivod_url = nil
      return nil
    end
    committee_name = info_section.css('h4').text.sub('會議別 ：', '').strip
    meeting_description = info_section.css('p.brief_text').text.sub('會  議  簡  介：', '').strip
    self.committee_id = Committee.where(name: committee_name).first.try(:id)
    self.meeting_description = meeting_description
    if ivod_uri.path.split('/')[2] == 'Full'
      date = info_section.css('p')[1].text.sub('會  議  時  間：', '').split(' ')[0].strip
      self.date = date
    elsif ivod_uri.path.split('/')[2] == 'VOD'
      legislator_name = info_section.css('p')[1].text.sub('委  員  名  稱：', '').strip
      date = info_section.css('p')[4].text.sub('會  議  時  間：', '').split(' ')[0].strip
      legislator = Legislator.where(name: legislator_name).first
      self.date = date
      if legislator
        self.legislators << legislator unless self.legislators.include?(legislator)
      end
    end
  end

  def update_ad_session_values
    unless self.date
      return nil
    end
    self.ad_session = AdSession.current_ad_session(self.date).first
  end

  def extract_youtube_id(url)
    youtube_uri = URI.parse(url)
    if youtube_uri.host == 'www.youtube.com'
      params = youtube_uri.query
      if params
        youtube_id = CGI::parse(params)['v'].first
      else
        youtube_id = youtube_uri.path.split('/')[-1]
      end
    elsif youtube_uri.host == 'youtu.be'
      youtube_id = youtube_uri.path[1..-1]
    else
      raise 'youtube id not found'
    end
  end

  private

  def is_youtube_url
    youtube_uri = URI.parse(self.youtube_url)
    errors.add(:base, 'is not youtube url') unless ['www.youtube.com', 'youtu.be'].include?(youtube_uri.try(:host))
    begin
      errors.add(:base, 'youtube url error') unless HTTParty.get(self.youtube_url).code == 200
    rescue
      errors.add(:base, 'youtube url error')
    end
  end

  def is_ivod_url
    unless self.ivod_url
      return nil
    end
    ivod_uri = URI.parse(self.ivod_url)
    errors.add(:base, 'is not ivod url') unless ['ivod.ly.gov.tw'].include?(ivod_uri.try(:host))
    begin
      errors.add(:base, 'ivod url error') unless HTTParty.get(self.ivod_url).code == 200
    rescue
      errors.add(:base, 'ivod url error')
    end
  end

  def has_at_least_one_legislator
    errors.add(:base, 'must add at least one legislator') if self.legislators.blank?
  end
end
