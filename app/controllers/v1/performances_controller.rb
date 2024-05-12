# frozen_string_literal: true

module V1
  class PerformancesController < ApplicationController
    def create
      result = PlayerPerformanceService.new.call(params.to_unsafe_hash)

      if result.success?
        render json: { message: 'Performance successfully recorded', details: result.value! }, status: :created
      else
        render json: { errors: result.failure.to_h }, status: :unprocessable_entity
      end
    end

    def check_indicator
      result = PerformanceCheckService.new.call(params.to_unsafe_hash)

      if result.success?
        render json: { status: result.value! }, status: :ok
      else
        render json: { error: result.failure }, status: :internal_server_error
      end
    end

    def top_performers
      result = TopPerformersService.new.call(params.to_unsafe_hash)

      if result.success?
        render json: result.value!.as_json(only: %i[id name performances_count])
      else
        render json: { error: result.failure }, status: :unprocessable_entity
      end
    end
  end
end
