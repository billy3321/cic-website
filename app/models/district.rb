class District < ActiveRecord::Base
  belongs_to :county
  has_and_belongs_to_many :elections, -> { uniq }
  has_many :legislators, through: :elections

  before_destroy { elections.clear }
end
