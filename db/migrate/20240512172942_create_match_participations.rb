class CreateMatchParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :match_participations do |t|
      t.references :team, null: false, foreign_key: { on_delete: :cascade }
      t.references :match, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end
