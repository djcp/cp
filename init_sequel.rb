require 'rubygems'
require 'sequel'
require 'sinatra'
require 'init'

DB = Sequel.connect(
  [
    settings.db_type,'://', 
    settings.db_username,':',
    settings.db_password,'@', 
    settings.db_host, ':', 
    settings.db_port, '/', 
    settings.db_name
].join(''))

DB.drop_table :project_skills if DB.table_exists?(:project_skills)

DB.create_table! :skills do
  primary_key :skill_id
  String :name, :size => 1024, :index => true, :unique => true, :null => false
  String :url, :size => 512, :index => true
  String :description
  Integer :skill_level, :index => true
end

DB.drop_table :project_images if DB.table_exists?(:project_images)

DB.create_table! :projects do
  primary_key :project_id
  String :name, :size => 1024, :index => true, :unique => true, :null => false
  String :url, :size => 512, :index => true
  String :source_code_url, :size => 512
  String :summary, :size => 1024
  String :description
  Date :project_date, :index => true
end

DB.create_table! :project_images do
  primary_key :project_image_id
  foreign_key :project_id, :projects, :on_delete => :cascade, :on_update => :cascade
  String :path, :size => 512
  Integer :size
  String :name => 128
end

DB.create_table! :project_skills do
  foreign_key :project_id, :projects, :on_delete => :cascade, :on_update => :cascade
  foreign_key :skill_id, :skills, :on_delete => :cascade, :on_update => :cascade
  primary_key [:project_id, :skill_id]
  Integer :amount, :default => 30
end
