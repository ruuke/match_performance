# frozen_string_literal: true

FactoryBot.define do
  factory :performance_indicator do
    description { Faker::Lorem.word }
  end
end
