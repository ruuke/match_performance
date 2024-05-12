# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "V1::Performances", type: :request do
  describe 'POST /v1/performances' do
    let(:team) { create(:team) }
    let(:player) { create(:player, team: team) }
    let(:match) { create(:match) }
    let(:performance_indicator) { create(:performance_indicator) }
    let!(:match_participation) { create(:match_participation, team: team, match: match) }

    let(:valid_attributes) {
      {
        player_id: player.id,
        match_id: match.id,
        performance_indicator_id: performance_indicator.id,
        achieved: true
      }
    }

    let(:invalid_attributes) {
      {
        player_id: nil,
        match_id: nil,
        performance_indicator_id: nil,
        achieved: nil
      }
    }

    context 'with valid parameters' do
      it 'creates a new Performance record' do
        expect {
          post v1_performances_path, params: valid_attributes
        }.to change(PlayerMatchPerformance, :count).by(1)

        expect(response).to have_http_status(:created) # Убедитесь, что контроллер возвращает :created
        expect(response.content_type).to include("application/json")
        expect(response.body).to include('Performance successfully recorded')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Performance record' do
        expect {
          post v1_performances_path, params:invalid_attributes
        }.to change(PlayerMatchPerformance, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
        expect(response.body).to include('errors')
      end
    end
  end

  describe 'GET /v1/performances/check_indicator' do
    let(:team) { create(:team) }
    let(:player) { create(:player, team: team) }
    let(:match) { create(:match) }
    let(:performance_indicator) { create(:performance_indicator) }
    let!(:match_participation) { create(:match_participation, team: team, match: match) }

    context 'when the performance indicator was achieved' do
      before do
        create(:player_match_performance,
               player: player,
               match: match,
               performance_indicator: performance_indicator,
               achieved: true)
      end

      it 'returns true' do
        get check_indicator_v1_performances_path, params: { player_id: player.id, indicator_id: performance_indicator.id }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('true')
      end
    end

    context 'when the performance indicator was not achieved' do
      before do
        5.times do
          match = create(:match)
          create(:match_participation, team: team, match: match)
          create(:player_match_performance,
                 player: player,
                 match: match,
                 performance_indicator: performance_indicator,
                 achieved: false)
        end
      end

      it 'returns false' do
        get check_indicator_v1_performances_path, params: { player_id: player.id, indicator_id: performance_indicator.id }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('false')
      end
    end
  end
end

