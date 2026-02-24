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

ActiveRecord::Schema[8.1].define(version: 2026_02_24_030316) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "characters", force: :cascade do |t|
    t.text "bio"
    t.string "character_class"
    t.datetime "created_at", null: false
    t.string "gender"
    t.string "name"
    t.string "race"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.integer "roll_result"
    t.bigint "story_id", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_messages_on_story_id"
  end

  create_table "queries", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "error"
    t.string "history"
    t.string "info"
    t.string "language"
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.integer "health_points"
    t.integer "level"
    t.string "mood"
    t.string "setting"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_stories_on_character_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "characters", "users"
  add_foreign_key "messages", "stories"
  add_foreign_key "stories", "characters"
end
