# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_01_182436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apiaries", force: :cascade do |t|
    t.bigint "user_id"
    t.string "uuid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_apiaries_on_user_id"
  end

  create_table "doors", force: :cascade do |t|
    t.integer "status"
    t.integer "last_command"
    t.bigint "hive_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hive_id"], name: "index_doors_on_hive_id"
  end

  create_table "hives", force: :cascade do |t|
    t.string "uuid"
    t.bigint "apiary_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["apiary_id"], name: "index_hives_on_apiary_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "raw"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scale_measures", force: :cascade do |t|
    t.integer "raw"
    t.decimal "weight"
    t.datetime "measured_at"
    t.bigint "scale_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["scale_id"], name: "index_scale_measures_on_scale_id"
  end

  create_table "scales", force: :cascade do |t|
    t.integer "tare"
    t.decimal "slope"
    t.bigint "hive_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hive_id"], name: "index_scales_on_hive_id"
  end

  create_table "temperature_grids", force: :cascade do |t|
    t.bigint "hive_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hive_id"], name: "index_temperature_grids_on_hive_id"
  end

  create_table "temperature_measures", force: :cascade do |t|
    t.decimal "temperature"
    t.datetime "measured_at"
    t.bigint "temperature_sensor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["temperature_sensor_id"], name: "index_temperature_measures_on_temperature_sensor_id"
  end

  create_table "temperature_sensors", force: :cascade do |t|
    t.integer "position"
    t.string "uuid"
    t.bigint "temperature_grid_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["temperature_grid_id"], name: "index_temperature_sensors_on_temperature_grid_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "apiaries", "users"
  add_foreign_key "doors", "hives"
  add_foreign_key "hives", "apiaries"
  add_foreign_key "scale_measures", "scales"
  add_foreign_key "scales", "hives"
  add_foreign_key "temperature_grids", "hives"
  add_foreign_key "temperature_measures", "temperature_sensors"
  add_foreign_key "temperature_sensors", "temperature_grids"
end
