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

ActiveRecord::Schema[8.1].define(version: 2025_12_16_094705) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.jsonb "settings", default: {}
    t.integer "status", default: 0
    t.string "subdomain", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain"], name: "index_agencies_on_subdomain", unique: true
  end

  create_table "features", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "default_config"
    t.text "dependencies"
    t.text "description"
    t.integer "display_order", default: 0
    t.boolean "is_agency_only", default: false
    t.boolean "is_core", default: false
    t.string "key", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "version", default: "1.0.0"
    t.index ["category"], name: "index_features_on_category"
    t.index ["is_core"], name: "index_features_on_is_core"
    t.index ["key"], name: "index_features_on_key", unique: true
  end

  create_table "tenant_features", force: :cascade do |t|
    t.text "configuration"
    t.datetime "created_at", null: false
    t.bigint "feature_id", null: false
    t.datetime "installed_at"
    t.boolean "is_enabled", default: false
    t.bigint "tenant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_tenant_features_on_feature_id"
    t.index ["tenant_id", "feature_id"], name: "index_tenant_features_on_tenant_id_and_feature_id", unique: true
    t.index ["tenant_id", "is_enabled"], name: "index_tenant_features_on_tenant_id_and_is_enabled"
    t.index ["tenant_id"], name: "index_tenant_features_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.boolean "is_agency_tenant", default: false
    t.string "name"
    t.integer "status"
    t.string "subdomain"
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_tenants_on_agency_id"
    t.index ["subdomain"], name: "index_tenants_on_subdomain", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 3
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_users_on_agency_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "tenant_features", "features"
  add_foreign_key "tenant_features", "tenants"
  add_foreign_key "tenants", "agencies"
  add_foreign_key "users", "agencies"
  add_foreign_key "users", "tenants"
end
