class Legislator < ActiveRecord::Base
  has_many :elections
  has_many :ads, through: :elections
  has_many :parties, through: :elections
  has_many :legislator_committees
  has_many :ad_sessions, through: :legislator_committees
  has_many :ccw_legislator_data, through: :legislator_committees
  has_and_belongs_to_many :entries, -> { uniq }
  has_and_belongs_to_many :interpellations, -> { uniq }
  has_and_belongs_to_many :videos, -> { uniq }
  validates_presence_of :name
  default_scope { order(name: :asc) }

  scope :current_legislators, -> {
    where(in_office: true)
  }

  scope :current_party, -> (abbr_name) {
    joins(elections: :party).where(parties: {abbreviation: abbr_name})
  }

  scope :order_by_entries_created, -> {
    unscoped.
    joins(:entries).
    order("entries.created_at DESC") }

  scope :order_by_interpellations_created, -> {
    unscoped.
    joins(:interpellations).
    order("interpellations.created_at DESC") }

  scope :order_by_videos_created, -> {
    unscoped.
    joins(:videos).
    order("videos.created_at DESC") }

  scope :has_records, -> {
    select("legislators.*, (count(legislators_videos.video_id) +
      count(interpellations_legislators.interpellation_id) +
      count(entries_legislators.entry_id)) AS associations_count").
    joins('LEFT OUTER JOIN "legislators_videos" ON "legislators_videos"."legislator_id" = "legislators"."id"
      LEFT OUTER JOIN "interpellations_legislators" ON "interpellations_legislators"."legislator_id" = "legislators"."id"
      LEFT OUTER JOIN "entries_legislators" ON "entries_legislators"."legislator_id" = "legislators"."id"').
    group("legislators.id").
    having("(count(legislators_videos.video_id) +
      count(interpellations_legislators.interpellation_id) +
      count(entries_legislators.entry_id)) > 0").
    order("associations_count DESC") }

  scope :has_no_record, -> {
    joins('LEFT OUTER JOIN "legislators_videos" ON "legislators_videos"."legislator_id" = "legislators"."id"
      LEFT OUTER JOIN "interpellations_legislators" ON "interpellations_legislators"."legislator_id" = "legislators"."id"
      LEFT OUTER JOIN "entries_legislators" ON "entries_legislators"."legislator_id" = "legislators"."id"').
    group("legislators.id").
    having("(count(legislators_videos.video_id) +
      count(interpellations_legislators.interpellation_id) +
      count(entries_legislators.entry_id)) = 0")
  }

  scope :order_by_videos_count, -> {
    unscoped.
    select("legislators.*, count(legislators_videos.video_id) AS videos_count").
    joins(:legislators_videos).
    group("legislators.id").
    order("videos_count DESC") }

  scope :order_by_entries_count, -> {
    unscoped.
    select("legislators.*, count(entries_legislators.entry_id) AS entries_count").
    joins(:legislators_entries).
    group("legislators.id").
    order("entries_count DESC") }

  scope :order_by_interpellations_count, -> {
    unscoped.
    select("legislators.*, count(interpellations_legislators.interpellation_id) AS interpellations_count").
    joins(:interpellations_legislators).
    group("legislators.id").
    order("interpellations_count DESC") }

  def party
    if self.now_party_id
      Party.find(self.now_party_id)
    else
      self.elections.any? ? self.elections.last.party : Party.where(abbreviation: nil).first
    end
  end

  def get_election(ad_id)
    return self.elections.where(ad_id: ad_id).first
  end

  def get_session_ccw_data(session_id)
    legislator_committees = self.legislator_committees.where(ad_session_id: session_id)
    return legislator_committees.map{ |l| l.ccw_legislator_datum }.select{ |c| c unless c.blank? }
  end

  def get_session_committee(session_id, kind = nil)
    legislator_committees = self.legislator_committees.where(ad_session_id: session_id)
    result = legislator_committees.map{ |l| l.committee }.select{ |c| c unless c.blank? }
    if kind
      result = result.select{ |c| c if c.kind == kind }
    end
    return result
  end

  def has_record?
    self.videos.any? or self.entries.any? or self.interpellations.any?
  end
end





