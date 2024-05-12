# frozen_string_literal: true

class PerformanceCheckService
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  ParamsSchema = Dry::Schema.Params do
    required(:player_id).filled(:integer)
    required(:indicator_id).filled(:integer)
  end

  def call(params)
    validated_params = yield validate_params(params)
    player = yield find_player(validated_params[:player_id])
    indicator = yield find_indicator(validated_params[:indicator_id])
    check_indicator(player, indicator)
  end

  private

  def validate_params(params)
    result = ParamsSchema.call(params)
    result.success? ? Success(result.to_h) : Failure(result.errors.to_h)
  end

  def find_player(player_id)
    player = Player.find_by(id: player_id)
    player ? Success(player) : Failure('Player not found')
  end

  def find_indicator(indicator_id)
    indicator = PerformanceIndicator.find_by(id: indicator_id)
    indicator ? Success(indicator) : Failure('Performance indicator not found')
  end

  def check_indicator(player, indicator)
    recent_matches = player.matches.order(date: :desc).limit(5)
    indicator_achieved = PlayerMatchPerformance.where(
      player:,
      match: recent_matches,
      performance_indicator: indicator,
      achieved: true
    ).exists?
    Success(indicator_achieved)
  end
end
