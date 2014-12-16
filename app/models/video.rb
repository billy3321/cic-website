class Video < ActiveRecord::Base
  has_and_belongs_to_many :legislators
  belongs_to :user
  belongs_to :committee
  validates_presence_of :yotuube_id
  validate :has_at_least_one_legislator
  validate :is_youtube_url

  before_save :update_other_values

  def update_other_values
    self.youtube_id = extract_youtube_id(self.youtube_url)
    api_url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' + youtube_id + '&key=' + Setting.google_public_key.api_key
    response = HTTPClient.get(api_url)
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
      self.content = result['items'][0]['snippet']['description'].gsub(/[\n]/,"<br />")
    end
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
  end

  def has_at_least_one_legislator
    errors.add(:base, 'must add at least one legislator') if self.legislators.blank?
  end
end
