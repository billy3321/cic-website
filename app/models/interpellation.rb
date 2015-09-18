class Interpellation < ActiveRecord::Base
  has_and_belongs_to_many :legislators, -> { uniq }
  has_and_belongs_to_many :keywords, -> { uniq }
  belongs_to :user
  belongs_to :committee
  belongs_to :ad_session
  validates_presence_of :content, message: '必須填寫質詢內容'
  validates_presence_of :user_id, message: '必須有回報者'
  validate :has_at_least_one_legislator
  validate :is_ivod_url
  validate :record_validate
  delegate :ad, :to => :ad_session, :allow_nil => true

  before_save :update_ivod_values, :update_ad_session_values, :update_title_values
  after_save :touch_legislators
  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :created_in_time_count, ->(date, duration) { where(created_at: (date..(date + duration))).count }
  scope :created_after, -> (date) { where("created_at > ?", date) }
  before_destroy { legislators.clear }
  before_destroy { keywords.clear }
  before_destroy :touch_legislators


  def update_ivod_values
    if self.ivod_url.to_s == ''
      return nil
    end
    ivod_uri = URI.parse(self.ivod_url)
    html = Nokogiri::HTML(open(self.ivod_url))
    info_section = html.css('div.legislator-video div.video-text')[0]
    if info_section.blank?
      # the ivod url is error
      self.ivod_url = nil
      errors.add(:base, 'ivod網址錯誤')
      return false
    elsif info_section.css('p')[3].text == '第屆 第會期'
      self.ivod_url = nil
      errors.add(:base, 'ivod網址錯誤')
      return false
    end
    self.ivod_url.sub!(/300K$/, '1M')
    committee_name = info_section.css('h4').text.sub('主辦單位 ：', '').strip
    meeting_description = info_section.css('p.brief_text').text.sub('會議簡介：', '').strip
    self.committee_id = Committee.where(name: committee_name).first.try(:id)
    self.meeting_description = meeting_description
    if ivod_uri.path.split('/')[2].downcase == 'full'
      date = info_section.css('p')[4].text.sub('會議時間：', '').split(' ')[0].strip
      self.date = date
    elsif ivod_uri.path.split('/')[2].downcase == 'vod'
      legislator_name = info_section.css('p')[4].text.sub('委員名稱：', '').strip
      date = info_section.css('p')[7].text.sub('會議時間：', '').split(' ')[0].strip
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
      self.title = "#{legislator_name}"
      if self.ad_session
        self.title += " #{self.ad.name}#{self.ad_session.name}"
      end
      if self.committee
        self.title += " #{self.committee.name}"
      end
      self.title += " #{self.date.strftime('%Y-%m-%d')}"
    end
  end

  def touch_legislators
    self.legislators.each(&:touch)
  end

  private

  def is_ivod_url
    if self.ivod_url.to_s == ''
      if ['record'].include? self.interpellation_type
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
    end
  end

  def record_validate
    if self.interpellation_type == 'record'
      error = 0
      if self.date.to_s == ''
        error = 1
        errors.add(:base, '必須填寫議事日期')
      end
      unless self.record_url.to_s == ''
        begin
          record_uri = URI.parse(URI.escape(self.record_url))
          unless HTTParty.get(URI.escape(self.record_url)).code == 200
            errors.add(:base, '議事錄網址無法存取')
            error = 1
          end
        rescue
          self.record_url = nil
          errors.add(:base, '議事錄網址錯誤')
          error = 1
        end
      end
      if self.committee_id == nil
        error = 1
        errors.add(:base, '請選擇所屬委員會')
      end
      if self.title.to_s == ''
        error = 1
        errors.add(:base, '請填寫標題')
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
