class Keyword < ActiveRecord::Base
  has_and_belongs_to_many :entries, -> { uniq }
  has_and_belongs_to_many :questions, -> { uniq }
  has_and_belongs_to_many :videos, -> { uniq }
end
