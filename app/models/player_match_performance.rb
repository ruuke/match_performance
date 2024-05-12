# frozen_string_literal: true

class PlayerMatchPerformance < ApplicationRecord
  belongs_to :player
  belongs_to :match
  belongs_to :performance_indicator

  validates :achieved, inclusion: { in: [true, false] }
end
