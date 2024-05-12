# frozen_string_literal: true

class MatchParticipation < ApplicationRecord
  belongs_to :team
  belongs_to :match
end
