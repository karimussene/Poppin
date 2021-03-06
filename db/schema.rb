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

ActiveRecord::Schema.define(version: 2019_09_12_122918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cuisines", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ranking"
  end

  create_table "favorite_cuisines", force: :cascade do |t|
    t.bigint "cuisine_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "compare", default: false
    t.index ["cuisine_id"], name: "index_favorite_cuisines_on_cuisine_id"
    t.index ["user_id"], name: "index_favorite_cuisines_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "cuisine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "season", default: [], array: true
    t.string "city"
    t.index ["cuisine_id"], name: "index_matches_on_cuisine_id"
    t.index ["user_id"], name: "index_matches_on_user_id"
  end

  create_table "restaurant_cuisines", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.bigint "cuisine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cuisine_id"], name: "index_restaurant_cuisines_on_cuisine_id"
    t.index ["restaurant_id"], name: "index_restaurant_cuisines_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.integer "attendance"
    t.integer "capacity"
    t.integer "rating"
    t.integer "price_range"
    t.string "photo"
    t.bigint "city_id"
    t.bigint "cuisine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["city_id"], name: "index_restaurants_on_city_id"
    t.index ["cuisine_id"], name: "index_restaurants_on_cuisine_id"
  end

  create_table "trends", force: :cascade do |t|
    t.string "location"
    t.string "cuisine_trend"
    t.string "month"
    t.string "value"
    t.bigint "city_id"
    t.bigint "cuisine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "moving_average"
    t.float "scaled_attendance"
    t.string "date"
    t.index ["city_id"], name: "index_trends_on_city_id"
    t.index ["cuisine_id"], name: "index_trends_on_cuisine_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "matches", "cuisines"
  add_foreign_key "matches", "users"
  add_foreign_key "restaurant_cuisines", "cuisines"
  add_foreign_key "restaurant_cuisines", "restaurants"
  add_foreign_key "trends", "cities"
  add_foreign_key "trends", "cuisines"
end
