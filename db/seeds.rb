require 'factory_bot_rails'

teams = FactoryBot.create_list(:team, 2, name: Faker::Sports::Football.team)

teams.each do |team|
  FactoryBot.create_list(:player, 3, team: team)
end

matches = FactoryBot.create_list(:match, 3, date: Faker::Date.in_date_period, location: Faker::Address.city)

indicators = FactoryBot.create_list(:performance_indicator, 2, description: Faker::Lorem.word)

teams.each do |team|
  matches.each do |match|
    FactoryBot.create(:match_participation, team: team, match: match)
  end
end

Player.all.each do |player|
  player.team.matches.each do |match|
    FactoryBot.create(:player_match_performance,
      player: player,
      match: match,
      performance_indicator: indicators.sample,
      achieved: [true, false].sample)
  end
end
