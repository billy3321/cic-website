class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  has_many :entries
  has_many :questions
  has_many :videos
  validates_presence_of :name, :email
  validates :agreement, acceptance: { accept: true }, on: :create, message: "請閱讀後同意使用條款。"
  scope :created_in_time_count, ->(date, duration) { where(created_at: (date..(date + duration))).count }
  scope :login_from, -> (provider) { provider.to_s == '' ? where("provider IS NULL") : where("provider = ?", provider) }

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :provider_uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.provider = auth.provider
        registered_user.provider_uid = auth.uid
        registered_user.save
        return registered_user
      else
        user = User.create(name:auth.info.name,
                            provider:auth.provider,
                            provider_uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20]
                          )
      end
    end
  end

  def self.find_for_google_oauth2(auth, signed_in_resource=nil)
    data = auth.info
    user = User.where(:provider => auth.provider, :provider_uid => auth.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.provider = auth.provider
        registered_user.provider_uid = auth.uid
        registered_user.save
        return registered_user
      else
        user = User.create(name: data["name"],
          provider:auth.provider,
          email: data["email"],
          provider_uid: auth.uid ,
          password: Devise.friendly_token[0,20]
        )
      end
    end
  end

end
