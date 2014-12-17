class Question < ActiveRecord::Base
  has_and_belongs_to_many :legislators
  has_and_belongs_to_many :keywords
  belongs_to :user
  belongs_to :committee
  belongs_to :ad_session
  validates_presence_of :ivod_url
  validate :has_at_least_one_legislator
  validate :is_ivod_url
  delegate :ad, :to => :ad_session, :allow_nil => true

  before_save :update_ivod_values
  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }

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

  private

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
