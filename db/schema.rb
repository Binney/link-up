# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140923134027) do

  create_table "articles", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "diary_entries", force: true do |t|
    t.integer  "user_id"
    t.datetime "start_time"
    t.integer  "event_id",   default: 0
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps",        default: true
    t.string   "cost_details"
    t.string   "contact"
    t.string   "website"
    t.string   "gender"
    t.integer  "cost"
    t.string   "schedule"
    t.integer  "user_id"
    t.integer  "max_age"
    t.integer  "min_age"
  end

  add_index "events", ["venue_id"], name: "index_events_on_venue_id"

  create_table "favourites", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
  end

  add_index "favourites", ["event_id"], name: "index_favourites_on_event_id"
  add_index "favourites", ["user_id", "event_id"], name: "index_favourites_on_user_id_and_event_id_and_day"
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id"

  create_table "logbook_entries", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_id"
  end

  add_index "logbook_entries", ["user_id", "template_id"], name: "index_logbook_entries_on_user_id_and_template_id", unique: true

  create_table "logbook_templates", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.datetime "start_time"
  end

  create_table "mentorships", force: true do |t|
    t.integer  "mentor_id"
    t.integer  "mentee_id"
    t.integer  "confirmation_stage", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "subject"
    t.text     "message"
    t.boolean  "unread",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "relationships", force: true do |t|
    t.integer  "tag_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["event_id"], name: "index_relationships_on_event_id"
  add_index "relationships", ["tag_id", "event_id"], name: "index_relationships_on_tag_id_and_event_id", unique: true
  add_index "relationships", ["tag_id"], name: "index_relationships_on_tag_id"

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "venue_id"
    t.text     "content"
    t.integer  "stars"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",   default: false
    t.string   "title"
  end

  create_table "schools", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teacher_code"
    t.string   "student_code"
    t.integer  "venue_id"
    t.string   "mentor_code"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name"

  create_table "timings", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "day"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "home_address"
    t.string   "home_postcode"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps",                  default: true
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "role",                   default: "student"
    t.integer  "mentor_meetings"
    t.integer  "school_id"
    t.text     "about"
    t.text     "interests"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["mentor_meetings"], name: "index_users_on_mentor_meetings"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "venues", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "street_address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps",          default: true
    t.string   "contact"
  end

  add_index "venues", ["name"], name: "index_venues_on_name"

end
