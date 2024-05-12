class CreateMatchParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :match_participations do |t|
      t.references :team, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
