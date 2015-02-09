class Video < ActiveRecord::Base
  has_and_belongs_to_many :legislators, -> { uniq }
  has_and_belongs_to_many :keywords, -> { uniq }
  belongs_to :user
  belongs_to :committee
  belongs_to :ad_session
  paginates_per 9
  validates_presence_of :youtube_url, message: '必須填寫youtube網址'
  validates_presence_of :title, message: '必須填寫影片標題'
  validates_presence_of :user_id, message: '必須有回報者'
  validate :has_at_least_one_legislator
  validate :is_youtube_url, :is_ivod_url, :news_validate
  delegate :ad, :to => :ad_session, :allow_nil => true
  before_save :update_youtube_values, :update_ivod_values, :update_ad_session_values
  after_save :touch_legislators
  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :created_in_time_count, ->(date, duration) { where(created_at: (date..(date + duration))).count }
  scope :created_after, -> (date) { where("created_at > ?", date) }
  before_destroy { legislators.clear }
  before_destroy { keywords.clear }
  before_destroy :touch_legislators


  def update_youtube_values
    youtube_id = extract_youtube_id(self.youtube_url)
    unless youtube_id
      self.youtube_url = nil
      errors.add(:base, 'youtube網址錯誤')
      return false
    end
    if self.youtube_id == youtube_id
      # means that youtube is the same, no need to update.
      return nil
    end
    self.youtube_id = youtube_id
    self.youtube_url = "https://www.youtube.com/watch?v=" + self.youtube_id
    api_url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' + self.youtube_id + '&key=' + Setting.google_public_key.api_key
    response = HTTParty.get(api_url)
    result = JSON.parse(response.body)
    unless result['items'].any?
      self.youtube_url = nil
      errors.add(:base, 'youtube網址錯誤')
      return false
    end
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
    if self.ivod_url.to_s == '' and self.video_type == 'news'
      return true
    end
    ivod_uri = URI.parse(self.ivod_url)
    html = Nokogiri::HTML(open(self.ivod_url))
    info_section = html.css('div.movie_box div.text')[0]
    unless info_section
      # the ivod url is error
      self.ivod_url = nil
      errors.add(:base, 'ivod網址錯誤')
      return false
    end
    self.ivod_url.sub!(/300K$/, '1M')
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
      errors.add(:base, '尚未填寫ivod網址')
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
      self.youtube_url = nil
      errors.add(:base, 'youtube網址錯誤')
      return false
    end
  end

  def touch_legislators
    self.legislators.each(&:touch)
  end

  private

  def is_youtube_url
    begin
      youtube_uri = URI.parse(self.youtube_url)
      errors.add(:base, '填寫網址非youtube網址') unless ['www.youtube.com', 'youtu.be'].include?(youtube_uri.try(:host))
      errors.add(:base, 'youtube網址無法存取') unless HTTParty.get(self.youtube_url).code == 200
    rescue
      errors.add(:base, 'youtube網址錯誤')
      return false
    end
  end

  def is_ivod_url
    if self.ivod_url.to_s == ''
      if self.video_type == 'news'
        return true
      else
        errors.add(:base, '必須填寫ivod出處網址')
        return false
      end
    end
    begin
      ivod_uri = URI.parse(self.ivod_url)
      errors.add(:base, '填寫網址非ivod網址') unless ['ivod.ly.gov.tw'].include?(ivod_uri.try(:host))
      errors.add(:base, 'ivod網址無法存取') unless HTTParty.get(self.ivod_url).code == 200
    rescue
      errors.add(:base, 'ivod網址錯誤')
      return false
    end
  end

  def news_validate
    if self.video_type == 'news'
      error = 0
      if self.date.to_s == ''
        error = 1
        errors.add(:base, '必須填寫新聞日期')
      end
      if self.source_url.to_s == ''
        error = 1
        errors.add(:base, '必須填寫新聞來源網址')
      else
        begin
          source_uri = URI.parse(self.source_url)
          unless HTTParty.get(self.source_url).code == 200
            errors.add(:base, '新聞來源網址無法存取')
            error = 1
          end
        rescue
          self.source_url = nil
          errors.add(:base, '新聞來源網址錯誤')
          error = 1
        end
      end
      if self.source_name.to_s == ''
        error = 1
        erros.add(:base, '必須填寫新聞來源名稱')
      end
      if error == 1
        return false
      else
        return true
      end
    else
      return true
    end
  end

  def has_at_least_one_legislator
    errors.add(:base, '必須填寫立委姓名！') if self.legislators.blank?
  end
end
