# frozen_string_literal: true

FactoryBot.define do
  factory :player_match_performance do
    player { nil }
    match { nil }
    performance_indicator { nil }
    achieved { false }
  end
end
