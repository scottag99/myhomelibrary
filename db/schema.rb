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

ActiveRecord::Schema.define(version: 2020_09_25_020738) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appreciation_notes", force: :cascade do |t|
    t.bigint "wishlist_id"
    t.binary "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "data"
    t.index ["wishlist_id"], name: "index_appreciation_notes_on_wishlist_id"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.text "description"
    t.integer "year"
    t.string "isbn"
    t.string "cover_image_url"
    t.string "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "ar_level"
    t.decimal "ar_points"
    t.string "grl"
    t.string "dra"
    t.boolean "is_bilingual", default: false
    t.boolean "is_chapter", default: false
  end

  create_table "campaign_catalogs", id: :serial, force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "catalog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_catalogs_on_campaign_id"
    t.index ["catalog_id"], name: "index_campaign_catalogs_on_catalog_id"
  end

  create_table "campaign_survey_configs", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "survey_id"
    t.string "teacher"
    t.boolean "is_disabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_control_group"
    t.index ["campaign_id"], name: "index_campaign_survey_configs_on_campaign_id"
    t.index ["survey_id"], name: "index_campaign_survey_configs_on_survey_id"
  end

  create_table "campaigns", id: :serial, force: :cascade do |t|
    t.string "name"
    t.date "deadline"
    t.integer "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ready_for_donations"
    t.string "address"
    t.boolean "can_edit_wishlists", default: true
    t.integer "book_limit"
    t.string "roster_data_reference"
    t.string "notes"
    t.boolean "use_appreciation_notes", default: false
    t.boolean "all_one_order", default: true
    t.index ["organization_id"], name: "index_campaigns_on_organization_id"
  end

  create_table "catalog_entries", id: :serial, force: :cascade do |t|
    t.integer "catalog_id"
    t.integer "book_id"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disabled", default: false
    t.integer "related_entry_id"
    t.index ["book_id"], name: "index_catalog_entries_on_book_id"
    t.index ["catalog_id"], name: "index_catalog_entries_on_catalog_id"
  end

  create_table "catalogs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "book_data_reference"
  end

  create_table "contents", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "action_name"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donations", id: :serial, force: :cascade do |t|
    t.integer "wishlist_id"
    t.decimal "amount"
    t.string "confirmation_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "campaign_id"
    t.boolean "is_classroom_sponsorship"
    t.boolean "is_in_kind"
    t.string "in_name_of"
    t.string "in_kind_message"
    t.boolean "is_grade_sponsorship"
    t.index ["campaign_id"], name: "index_donations_on_campaign_id"
    t.index ["wishlist_id"], name: "index_donations_on_wishlist_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.boolean "is_disabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "is_included", default: true
  end

  create_table "partners", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "active"
    t.integer "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_coordinator", default: false
    t.index ["organization_id"], name: "index_partners_on_organization_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reading_levels", force: :cascade do |t|
    t.string "name"
    t.boolean "is_disabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "survey_answers", force: :cascade do |t|
    t.bigint "survey_question_id"
    t.bigint "survey_response_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_question_id"], name: "index_survey_answers_on_survey_question_id"
    t.index ["survey_response_id"], name: "index_survey_answers_on_survey_response_id"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.string "question"
    t.text "description"
    t.bigint "survey_id"
    t.bigint "question_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "answer_options"
    t.integer "sequence", default: 1
    t.index ["question_type_id"], name: "index_survey_questions_on_question_type_id"
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "survey_responses", force: :cascade do |t|
    t.bigint "wishlist_id"
    t.bigint "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_responses_on_survey_id"
    t.index ["wishlist_id"], name: "index_survey_responses_on_wishlist_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "name"
    t.boolean "is_disabled", default: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wishlist_entries", id: :serial, force: :cascade do |t|
    t.integer "wishlist_id"
    t.integer "catalog_entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price"
    t.index ["catalog_entry_id"], name: "index_wishlist_entries_on_catalog_entry_id"
    t.index ["wishlist_id"], name: "index_wishlist_entries_on_wishlist_id"
  end

  create_table "wishlists", id: :serial, force: :cascade do |t|
    t.string "reader_name"
    t.integer "reader_age"
    t.string "reader_gender"
    t.integer "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "teacher"
    t.string "grade"
    t.string "grl"
    t.string "external_id"
    t.integer "wishlist_entry_count"
    t.boolean "is_delivered", default: false
    t.boolean "is_consent_given", default: true
    t.bigint "language_id"
    t.bigint "reading_level_id"
    t.index ["campaign_id"], name: "index_wishlists_on_campaign_id"
    t.index ["language_id"], name: "index_wishlists_on_language_id"
    t.index ["reader_name"], name: "index_wishlists_on_reader_name"
    t.index ["reading_level_id"], name: "index_wishlists_on_reading_level_id"
    t.index ["teacher"], name: "index_wishlists_on_teacher"
  end

  add_foreign_key "appreciation_notes", "wishlists"
  add_foreign_key "campaign_catalogs", "campaigns"
  add_foreign_key "campaign_catalogs", "catalogs"
  add_foreign_key "campaign_survey_configs", "campaigns"
  add_foreign_key "campaign_survey_configs", "surveys"
  add_foreign_key "campaigns", "organizations"
  add_foreign_key "catalog_entries", "books"
  add_foreign_key "catalog_entries", "catalog_entries", column: "related_entry_id"
  add_foreign_key "catalog_entries", "catalogs"
  add_foreign_key "donations", "campaigns"
  add_foreign_key "donations", "wishlists"
  add_foreign_key "partners", "organizations"
  add_foreign_key "survey_answers", "survey_questions"
  add_foreign_key "survey_answers", "survey_responses"
  add_foreign_key "survey_questions", "question_types"
  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "survey_responses", "surveys"
  add_foreign_key "survey_responses", "wishlists"
  add_foreign_key "wishlist_entries", "catalog_entries"
  add_foreign_key "wishlist_entries", "wishlists"
  add_foreign_key "wishlists", "campaigns"
  add_foreign_key "wishlists", "languages"
  add_foreign_key "wishlists", "reading_levels"
end
