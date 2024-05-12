class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.references :team, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
