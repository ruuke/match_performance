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
  end
end
