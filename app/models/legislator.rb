class Legislator < ActiveRecord::Base
  has_many :elections
  has_many :ads, through: :elections
  has_and_belongs_to_many :entries, -> { uniq }
  has_and_belongs_to_many :questions, -> { uniq }
  has_and_belongs_to_many :videos, -> { uniq }
  validates_presence_of :name

  scope :current_legislators, -> {
    where(in_office: true)
  }

  scope :order_by_videos_count, -> {
    select("legislators.*, count(legislators_videos.video_id) AS videos_count").
    joins(:legislators_videos).
    group("legislators.id").
    order("videos_count DESC") }

  scope :order_by_entries_count, -> {
    select("legislators.*, count(entries_legislators.entry_id) AS entries_count").
    joins(:legislators_entries).
    group("legislators.id").
    order("entries_count DESC") }

  scope :order_by_questions_count, -> {
    select("legislators.*, count(legislators_questions.question_id) AS questions_count").
    joins(:legislators_questions).
    group("legislators.id").
    order("questions_count DESC") }

  scope :order_by_all_count, -> {
    select("legislators.*, (count(legislators_videos.video_id) +
      count(legislators_questions.question_id) +
      count(entries_legislators.entry_id)) AS associations_count").
    joins('LEFT OUTER JOIN "legislators_videos" ON "legislators_videos"."legislator_id" = "legislators"."id"
      LEFT OUTER JOIN "legislators_questions" ON "legislators_questions"."legislator_id" = "legislators"."id"
      LEFT OUTER JOIN "entries_legislators" ON "entries_legislators"."legislator_id" = "legislators"."id"').
    group("legislators.id").
    having("(count(legislators_videos.video_id) +
      count(legislators_questions.question_id) +
      count(entries_legislators.entry_id)) > 0").
    order("associations_count DESC") }

  def party
    self.elections.any? ? self.elections.last.party : Party.where(abbreviation: nil).first
  end
end





