# frozen_string_literal: true

FactoryBot.define do
  factory :match_participation do
    team
    match
  end
end
