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

ActiveRecord::Schema[7.0].define(version: 2023_04_20_071821) do
  create_table "manipulators", force: :cascade do |t|
    t.string "名称"
    t.string "密码"
    t.string "类型"
    t.string "性别"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string "图片"
    t.integer "manipulator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manipulator_id"], name: "index_pictures_on_manipulator_id"
  end

  create_table "song_types", force: :cascade do |t|
    t.string "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pictures", "manipulators"
end
