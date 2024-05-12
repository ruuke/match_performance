# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    date { Faker::Date.between(from: 1.year.ago, to: Time.zone.today) }
    location { Faker::Address.city }
  end
end
