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

ActiveRecord::Schema.define(version: 20190222194841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appreciation_notes", force: :cascade do |t|
    t.bigint "wishlist_id"
    t.binary "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["campaign_id"], name: "index_donations_on_campaign_id"
    t.index ["wishlist_id"], name: "index_donations_on_wishlist_id"
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
    t.index ["campaign_id"], name: "index_wishlists_on_campaign_id"
    t.index ["reader_name"], name: "index_wishlists_on_reader_name"
    t.index ["teacher"], name: "index_wishlists_on_teacher"
  end

  add_foreign_key "appreciation_notes", "wishlists"
  add_foreign_key "campaign_catalogs", "campaigns"
  add_foreign_key "campaign_catalogs", "catalogs"
  add_foreign_key "campaigns", "organizations"
  add_foreign_key "catalog_entries", "books"
  add_foreign_key "catalog_entries", "catalog_entries", column: "related_entry_id"
  add_foreign_key "catalog_entries", "catalogs"
  add_foreign_key "donations", "campaigns"
  add_foreign_key "donations", "wishlists"
  add_foreign_key "partners", "organizations"
  add_foreign_key "wishlist_entries", "catalog_entries"
  add_foreign_key "wishlist_entries", "wishlists"
  add_foreign_key "wishlists", "campaigns"
end
