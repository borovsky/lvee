# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090308133803) do

  create_table "articles", :force => true do |t|
    t.string   "category"
    t.string   "name"
    t.string   "title"
    t.text     "body"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["category", "name", "locale"], :name => "index_articles_on_category_and_name_and_locale", :unique => true
  add_index "articles", ["category", "name"], :name => "index_articles_on_category_and_name"

  create_table "conference_registrations", :force => true do |t|
    t.integer "user_id"
    t.integer "conference_id"
    t.integer "quantity"
    t.text    "proposition"
    t.string  "status_name"
    t.string  "days"
    t.string  "food"
    t.string  "tshirt"
    t.string  "transport"
    t.string  "meeting"
    t.string  "phone"
    t.string  "user_type",     :default => "normal"
    t.integer "to_pay"
  end

  create_table "conferences", :force => true do |t|
    t.string  "name"
    t.date    "start_date"
    t.date    "finish_date"
    t.boolean "registration_opened"
  end

  create_table "languages", :id => false, :force => true do |t|
    t.string  "name",        :limit => 2
    t.string  "description"
    t.boolean "published"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "lead"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",       :limit => 2
    t.integer  "parent_id"
    t.datetime "published_at"
    t.integer  "version"
  end

  add_index "news", ["parent_id", "locale"], :name => "index_news_on_parent_id_and_locale", :unique => true

  create_table "news_versions", :force => true do |t|
    t.integer  "news_id"
    t.integer  "version"
    t.string   "title"
    t.text     "lead"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "updated_at"
    t.string   "locale",       :limit => 2
    t.integer  "parent_id"
    t.datetime "published_at"
  end

  add_index "news_versions", ["news_id"], :name => "index_news_versions_on_news_id"

  create_table "statuses", :force => true do |t|
    t.string "name"
  end

  add_index "statuses", ["name"], :name => "index_statuses_on_name_and_locale", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "country"
    t.string   "city"
    t.string   "occupation"
    t.text     "projects"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "role"
  end

end
