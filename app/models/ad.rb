class Ad < ActiveRecord::Base
  has_many :elections
  has_many :ad_sessions
  has_many :legislators, through: :elections
  has_many :parties, -> { uniq }, through: :elections
  has_many :entries, through: :ad_sessions
  has_many :interpellations, through: :ad_sessions
  has_many :videos, through: :ad_sessions
  validates_presence_of :name, :vote_date, :term_start, :term_end
  default_scope { order(vote_date: :asc) }
end
