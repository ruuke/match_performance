# frozen_string_literal: true

Dry::Schema.load_extensions(:monads)

class PlayerPerformanceService
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  PerformanceSchema = Dry::Schema.Params do
    required(:player_id).filled(:integer)
    required(:match_id).filled(:integer)
    required(:performance_indicator_id).filled(:integer)
    required(:achieved).filled(:bool)
  end

  def call(params)
    valid_params = yield validate_params(params)
    performance_record = yield record_performance(valid_params)
    Success(performance_record)
  end

  private

  def validate_params(params)
    result = PerformanceSchema.call(params)
    result.success? ? Success(result.to_h) : Failure(result.errors.to_h)
  end

  def record_performance(valid_params)
    performance = PlayerMatchPerformance.create(valid_params)
    performance.persisted? ? Success(performance) : Failure(performance: 'could not be saved')
  end
end
