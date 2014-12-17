class Ad < ActiveRecord::Base
  has_many :elections
  has_many :ad_sessions
  has_many :legislators, through: :elections
end
