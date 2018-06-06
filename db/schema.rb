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


ActiveRecord::Schema.define(version: 2018_06_06_092541) do


  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.string "description"
    t.integer "price"
    t.boolean "selected"
    t.bigint "search_id"
    t.bigint "provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_articles_on_provider_id"
    t.index ["search_id"], name: "index_articles_on_search_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "url"
    t.bigint "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_images_on_article_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "base_url"
    t.string "logo"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "name"
    t.string "open_hours"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_schedules_on_store_id"
  end

  create_table "searches", force: :cascade do |t|
    t.string "keywords"
    t.string "input_address"
    t.integer "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "size"
    t.boolean "available"
    t.bigint "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_stocks_on_article_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.float "latitude"
    t.float "longitude"
    t.bigint "provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_stores_on_provider_id"
  end

  add_foreign_key "articles", "providers"
  add_foreign_key "articles", "searches"
  add_foreign_key "images", "articles"
  add_foreign_key "schedules", "stores"
  add_foreign_key "stocks", "articles"
  add_foreign_key "stores", "providers"
end
