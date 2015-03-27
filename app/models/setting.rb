class Setting < Settingslogic
  source "#{Rails.root}/config/config.yml"
  namespace Rails.env

  def self.initialize_redis
    $redis = Redis.new(Setting.redis)
  end
end