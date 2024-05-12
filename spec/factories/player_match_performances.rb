# frozen_string_literal: true

FactoryBot.define do
  factory :player_match_performance do
    player
    match
    performance_indicator
    achieved { [true, false].sample }
  end
end
