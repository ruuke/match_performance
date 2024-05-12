# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :players
  has_many :match_participations
  has_many :matches, through: :match_participations

  validates :name, presence: true
end
