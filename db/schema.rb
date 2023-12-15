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

ActiveRecord::Schema[7.0].define(version: 2023_12_12_154304) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invoice_lines", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "description"
    t.string "unit_type"
    t.decimal "quantity", default: "1.0"
    t.decimal "price", default: "0.0"
    t.datetime "deleted_at", precision: nil
  end

  create_table "invoice_parties", force: :cascade do |t|
    t.string "name"
    t.string "company_number"
    t.string "street"
    t.string "city"
    t.string "type"
    t.string "postcode"
    t.string "country_code"
    t.bigint "invoice_id"
    t.datetime "deleted_at", precision: nil
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "subscription_id"
    t.string "number"
    t.datetime "issued_on", precision: nil
    t.datetime "due_on", precision: nil
    t.string "means_of_payment", default: "cash"
    t.float "total"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "paid_at", precision: nil
    t.datetime "submitted_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.virtual "state", type: :integer, as: "\nCASE\n    WHEN (paid_at IS NOT NULL) THEN 1\n    WHEN (submitted_at IS NOT NULL) THEN 2\n    ELSE 5\nEND", stored: true
    t.integer "recurring_profile_id"
    t.index ["recurring_profile_id"], name: "index_invoices_on_recurring_profile_id"
  end

  create_table "prismic_posts", id: :string, force: :cascade do |t|
    t.string "uid"
    t.string "author"
    t.string "slug"
    t.date "date"
    t.string "title"
    t.string "perex"
    t.string "image"
    t.string "body"
    t.string "category_slug"
    t.string "sub_category_slug"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recurring_profiles", force: :cascade do |t|
    t.string "frequency"
    t.date "ends_on"
    t.integer "ends_after_count"
    t.boolean "automatic_emails"
    t.integer "invoices_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
  end

end
