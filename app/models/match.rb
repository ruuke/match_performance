class Match < ApplicationRecord
  has_many :player_match_performances
  has_many :players, through: :player_match_performances

  validates :date, :location, presence: true
end
