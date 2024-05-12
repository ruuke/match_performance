# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :team
  has_many :player_match_performances
  has_many :matches, through: :team

  validates :name, presence: true
end
