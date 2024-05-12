# frozen_string_literal: true

class Match < ApplicationRecord
  has_many :match_participations
  has_many :teams, through: :match_participations
  has_many :player_match_performances

  validates :date, :location, presence: true
end
