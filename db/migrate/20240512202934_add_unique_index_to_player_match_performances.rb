class AddUniqueIndexToPlayerMatchPerformances < ActiveRecord::Migration[7.0]
  def change
    add_index :player_match_performances, [:player_id, :match_id, :performance_indicator_id], unique: true, name: 'index_unique_player_match_performance'
  end
end
