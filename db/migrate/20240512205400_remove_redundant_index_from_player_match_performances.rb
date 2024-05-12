class RemoveRedundantIndexFromPlayerMatchPerformances < ActiveRecord::Migration[7.0]
  def change
    remove_index :player_match_performances, name: 'index_player_match_performances_on_player_id'
  end
end
