# frozen_string_literal: true

class TopPerformersService
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  ParamsSchema = Dry::Schema.Params do
    required(:indicator_id).filled(:integer)
    optional(:team_id).maybe(:integer)
  end

  def call(params)
    input = yield validate(params)
    top_performers(input)
  end

  private

  def validate(params)
    result = ParamsSchema.call(params)
    result.success? ? Success(result.to_h) : Failure(result.errors.to_h)
  end

  def top_performers(input)
    scope = PlayerMatchPerformance.joins(:player)
                                  .where(performance_indicator_id: input[:indicator_id], achieved: true)
                                  .select('players.id, players.name, COUNT(player_match_performances.id) AS performances_count')
                                  .group('players.id')
                                  .order('performances_count DESC')
                                  .limit(5)

    scope = scope.where(players: { team_id: input[:team_id] }) if input[:team_id]
    Success(scope)
  rescue StandardError => e
    Failure(e.message)
  end
end
