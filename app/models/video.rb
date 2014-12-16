class Video < ActiveRecord::Base
  has_and_belongs_to_many :legislators
  belongs_to :user
  belongs_to :committee
  validates_presence_of :yotuube_id
  validate :has_at_least_one_legislator
  validate :is_youtube_url

  before_save do |youtube_url|
    begin
      youtube_url = extract_youtube_id(video.youtube_url)
      #"https://www.youtube.com/watch?v=oeRo-ydS0UE"
      #"http://youtu.be/oeRo-ydS0UE"
      video.youtube_id = youtube_id
      api_url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' + youtube_id + '&key=' + Setting.google_public_key.api_key
      response = HTTPClient.get(api_url)
      result = JSON.parse(response.body)
      if result['items'][0]['snippet']['thumbnails'].key?('maxres')
        video.image = result['items'][0]['snippet']['thumbnails']['maxres']['url']
      elsif result['items'][0]['snippet']['thumbnails'].key?('standard')
        video.image = result['items'][0]['snippet']['thumbnails']['standard']['url']
      elsif result['items'][0]['snippet']['thumbnails'].key?('high')
        video.image = result['items'][0]['snippet']['thumbnails']['high']['url']
      elsif result['items'][0]['snippet']['thumbnails'].key?('medium')
        video.image = result['items'][0]['snippet']['thumbnails']['medium']['url']
      elsif result['items'][0]['snippet']['thumbnails'].key?('default')
        video.image = result['items'][0]['snippet']['thumbnails']['default']['url']
      else
        video.image = ''
      end

      if video.title.blank?
        video.title = result['items'][0]['snippet']['title']
      end
      if video.content.blank?
        video.content = result['items'][0]['snippet']['description'].gsub(/[\n]/,"<br />")
      end
    # rescue => err
    #   puts ">>>>>>", err.inspect
    #   video.image = nil
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
    youtube_uri = URI.parse(self.youtube_id)
    errors.add(:base, 'is not youtube url') unless ['www.youtube.com', 'youtu.be'].include?(youtube_uri.try(:host))
  end

  def has_at_least_one_legislator
    errors.add(:base, 'must add at least one legislator') if self.legislators.blank?
  end
end
