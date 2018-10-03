# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_08_26_171917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "authorizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "travel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content", null: false
    t.uuid "user_id", null: false
    t.uuid "travel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_type", null: false
    t.uuid "source_id", null: false
    t.string "resource_type", null: false
    t.uuid "resource_id", null: false
    t.index ["resource_type", "resource_id"], name: "index_events_on_resource_type_and_resource_id"
    t.index ["source_type", "source_id"], name: "index_events_on_source_type_and_source_id"
  end

  create_table "favorites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "travel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "following_id", null: false
    t.uuid "follower_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "readed", default: false, null: false
    t.datetime "readed_at"
    t.uuid "user_id", null: false
    t.uuid "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.geography "coordinates", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "title", default: "", null: false
    t.text "description", default: "", null: false
    t.uuid "travel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "travels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "description", default: "", null: false
    t.text "image_public_url"
    t.text "thumbnail_public_url"
    t.boolean "publicx", default: true, null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "name"
    t.string "lastname"
    t.string "google_id"
    t.string "gender"
    t.text "image_url"
    t.text "image_public_url"
    t.text "thumbnail_public_url"
    t.text "description", default: "", null: false
    t.boolean "confirmed", default: false, null: false
    t.datetime "confirmed_at"
    t.jsonb "extra", default: "[]", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "uid"
    t.string "provider"
    t.text "oauth_token"
    t.text "oauth_refresh_token"
    t.datetime "oauth_expires_at"
    t.json "tokens"
    t.index ["email"], name: "index_users_on_email"
    t.index ["google_id", "provider"], name: "index_users_on_google_id_and_provider", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "authorizations", "travels", on_delete: :cascade
  add_foreign_key "authorizations", "users", on_delete: :cascade
  add_foreign_key "comments", "travels", on_delete: :cascade
  add_foreign_key "comments", "users", on_delete: :cascade
  add_foreign_key "favorites", "travels", on_delete: :cascade
  add_foreign_key "favorites", "users", on_delete: :cascade
  add_foreign_key "followings", "users", column: "follower_id", on_delete: :cascade
  add_foreign_key "followings", "users", column: "following_id", on_delete: :cascade
  add_foreign_key "notifications", "events", on_delete: :cascade
  add_foreign_key "notifications", "users", on_delete: :cascade
  add_foreign_key "places", "travels", on_delete: :cascade
  add_foreign_key "travels", "users", on_delete: :cascade
end
