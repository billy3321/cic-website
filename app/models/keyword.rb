class Keyword < ActiveRecord::Base
  has_and_belongs_to_many :entries
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :videos
end
