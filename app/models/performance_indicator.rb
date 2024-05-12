class PerformanceIndicator < ApplicationRecord
  has_many :player_match_performances

  validates :description, presence: true
end
