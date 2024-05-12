# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Performances', type: :request do
  describe 'POST /v1/performances' do
    let(:team) { create(:team) }
    let(:player) { create(:player, team:) }
    let(:match) { create(:match) }
    let(:performance_indicator) { create(:performance_indicator) }
    let!(:match_participation) { create(:match_participation, team:, match:) }

    let(:valid_attributes) do
      {
        player_id: player.id,
        match_id: match.id,
        performance_indicator_id: performance_indicator.id,
        achieved: true
      }
    end

    let(:invalid_attributes) do
      {
        player_id: nil,
        match_id: nil,
        performance_indicator_id: nil,
        achieved: nil
      }
    end

    context 'with valid parameters' do
      it 'creates a new Performance record' do
        expect do
          post v1_performances_path, params: valid_attributes
        end.to change(PlayerMatchPerformance, :count).by(1)

        expect(response).to have_http_status(:created) # Убедитесь, что контроллер возвращает :created
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('Performance successfully recorded')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Performance record' do
        expect do
          post v1_performances_path, params: invalid_attributes
        end.to change(PlayerMatchPerformance, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('errors')
      end
    end
  end

  describe 'GET /v1/performances/check_indicator' do
    let(:team) { create(:team) }
    let(:player) { create(:player, team:) }
    let!(:players) { create_list(:player, 5, team:) }
    let(:match) { create(:match) }
    let(:performance_indicator) { create(:performance_indicator) }
    let!(:match_participation) { create(:match_participation, team:, match:) }

    context 'when the performance indicator was achieved' do
      before do
        create(:player_match_performance,
               player:,
               match:,
               performance_indicator:,
               achieved: true)
      end

      it 'returns true' do
        get check_indicator_v1_performances_path,
            params: { player_id: player.id, indicator_id: performance_indicator.id }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('true')
      end
    end

    context 'when the performance indicator was not achieved' do
      before do
        5.times do
          match = create(:match)
          create(:match_participation, team:, match:)
          create(:player_match_performance,
                 player:,
                 match:,
                 performance_indicator:,
                 achieved: false)
        end
      end

      it 'returns false' do
        get check_indicator_v1_performances_path,
            params: { player_id: player.id, indicator_id: performance_indicator.id }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('false')
      end
    end
  end

  describe 'GET /v1/performances/top_performers' do
    let!(:team) { create(:team) }
    let!(:other_team) { create(:team) }
    let!(:indicator) { create(:performance_indicator) }
    let!(:players) { create_list(:player, 5, team:) }
    let!(:other_players) { create_list(:player, 5, team: other_team) }

    before do
      players.each_with_index do |player, index|
        create(:player_match_performance, player:, performance_indicator: indicator, achieved: true,
                                          match: create(:match, date: 10.days.ago + index.days))
      end
      other_players.each do |player|
        create(:player_match_performance, player:, performance_indicator: indicator,
                                          achieved: [true, false].sample, match: create(:match, date: 5.days.ago))
      end
    end

    context 'without team filter' do
      it 'returns top 5 performers across all teams' do
        get top_performers_v1_performances_path, params: { indicator_id: indicator.id }

        expect(response).to have_http_status(:ok)
        returned_player_ids = json_response.map { |p| p['id'] }
        top_performers_ids = PlayerMatchPerformance.joins(:player)
                                                   .where(performance_indicator: indicator, achieved: true)
                                                   .group(:player_id)
                                                   .order('count(player_match_performances.id) DESC')
                                                   .limit(5)
                                                   .pluck(:player_id)
        expect(returned_player_ids).to match_array(top_performers_ids)
      end
    end

    context 'with team filter' do
      it 'returns top performers for a specific team' do
        get top_performers_v1_performances_path, params: { indicator_id: indicator.id, team_id: team.id }

        expect(response).to have_http_status(:ok)
        returned_player_ids = json_response.map { |p| p['id'] }
        top_team_performers_ids = PlayerMatchPerformance.joins(:player)
                                                        .where(performance_indicator: indicator, achieved: true, players: { team_id: team.id })
                                                        .group(:player_id)
                                                        .order('count(player_match_performances.id) DESC')
                                                        .limit(5)
                                                        .pluck(:player_id)
        expect(returned_player_ids).to match_array(top_team_performers_ids)
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
