# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_12_205400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "match_participations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "match_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_participations_on_match_id"
    t.index ["team_id"], name: "index_match_participations_on_team_id"
  end

  create_table "matches", force: :cascade do |t|
    t.date "date"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performance_indicators", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_performance_indicators_on_description", unique: true
  end

  create_table "player_match_performances", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "match_id", null: false
    t.bigint "performance_indicator_id", null: false
    t.boolean "achieved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_player_match_performances_on_match_id"
    t.index ["performance_indicator_id"], name: "index_player_match_performances_on_performance_indicator_id"
    t.index ["player_id", "match_id", "performance_indicator_id"], name: "index_unique_player_match_performance", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "match_participations", "matches", on_delete: :cascade
  add_foreign_key "match_participations", "teams", on_delete: :cascade
  add_foreign_key "player_match_performances", "matches"
  add_foreign_key "player_match_performances", "performance_indicators"
  add_foreign_key "player_match_performances", "players"
  add_foreign_key "players", "teams", on_delete: :cascade
end
