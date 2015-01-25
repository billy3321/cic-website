class Question < ActiveRecord::Base
  has_and_belongs_to_many :legislators, -> { uniq }
  has_and_belongs_to_many :keywords, -> { uniq }
  belongs_to :user
  belongs_to :committee
  belongs_to :ad_session
  validates_presence_of :ivod_url, message: '必須填寫ivod出處之影片連結'
  validates_presence_of :content, message: '必須填寫質詢內容'
  validates_presence_of :user_id, message: '必須有回報者'
  validate :has_at_least_one_legislator
  validate :is_ivod_url
  delegate :ad, :to => :ad_session, :allow_nil => true
  validates_presence_of :title

  before_save :update_ivod_values, :update_ad_session_values, :update_title_values
  after_save :touch_legislators
  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :created_in_time_count, ->(date, duration) { where(created_at: (date..(date + duration))).count }
  scope :created_after, -> (date) { where("created_at > ?", date) }

  def update_ivod_values
    if self.ivod_url.to_s == ''
      return nil
    end
    ivod_uri = URI.parse(self.ivod_url)
    html = Nokogiri::HTML(open(self.ivod_url))
    info_section = html.css('div.movie_box div.text')[0]
    unless info_section
      # the ivod url is error
      self.ivod_url = nil
      errors.add(:base, 'ivod網址出錯')
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
      return nil
    end
    self.ad_session = AdSession.current_ad_session(self.date).first
  end

  def update_title_values
    if self.title.blank?
      legislator_name = self.legislators.map{ |l| l.name }.join('、')
      if self.ad_session
        self.title = "#{legislator_name} #{self.ad.name}#{self.ad_session.name} #{self.date.strftime('%Y-%m-%d')}"
      else
        self.title = "#{legislator_name} #{self.date.strftime('%Y-%m-%d')}"
      end
    end
  end

  def touch_legislators
    self.legislators.each(&:touch)
  end

  private

  def is_ivod_url
    if self.ivod_url.to_s == ''
      errors.add(:base, '尚未填寫ivod網址')
      return nil
    end
    begin
      ivod_uri = URI.parse(self.ivod_url)
      errors.add(:base, '填寫網址非ivod網址') unless ['ivod.ly.gov.tw'].include?(ivod_uri.try(:host))
      errors.add(:base, 'ivod網址無法存取') unless HTTParty.get(self.ivod_url).code == 200
    rescue
      errors.add(:base, 'ivod網址錯誤')
    end
  end

  def has_at_least_one_legislator
    errors.add(:base, '必須填寫立委姓名！') if self.legislators.blank?
  end
end
