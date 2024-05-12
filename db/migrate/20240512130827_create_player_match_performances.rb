class CreatePlayerMatchPerformances < ActiveRecord::Migration[7.0]
  def change
    create_table :player_match_performances do |t|
      t.references :player, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.references :performance_indicator, null: false, foreign_key: true
      t.boolean :achieved

      t.timestamps
    end
  end
end
