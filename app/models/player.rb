# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :team
  has_many :player_match_performances
  has_many :matches, through: :player_match_performances

  validates :name, presence: true
end
