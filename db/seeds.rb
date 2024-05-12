require 'factory_bot_rails'

Team.delete_all
Player.delete_all
Match.delete_all
PerformanceIndicator.delete_all
PlayerMatchPerformance.delete_all
MatchParticipation.delete_all

teams = FactoryBot.create_list(:team, 2)

teams.each do |team|
  FactoryBot.create_list(:player, 3, team: team)
end

matches = FactoryBot.create_list(:match, 3)

indicators = FactoryBot.create_list(:performance_indicator, 2)

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
