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
      service = PerformanceCheckService.new(
        player_id: params[:player_id],
        indicator_id: params[:indicator_id]
      )

      result = service.call

      if result.success?
        render json: { status: result.value! }, status: :ok
      else
        render json: { error: result.failure }, status: :internal_server_error
      end
    end
  end
end
