# frozen_string_literal: true

module V1
  class PerformancesController < ApplicationController
    def create
      result = PlayerPerformanceService.record_performance(params.to_unsafe_hash)

      if result.success?
        render json: { message: 'Performance successfully recorded', details: result.value! }
      else
        render json: { errors: result.failure.errors.to_h }, status: :unprocessable_entity
      end
    end
  end
end
