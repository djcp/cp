$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))
require 'rubygems'
require 'sequel'
require 'sinatra'
require 'erubis'
require 'init'
require 'helpers'
require 'cgi'
require 'partials'
# set :erubis, :escape_html => true

set :environment, :development

helpers Sinatra::Partials

Tilt.register 'html.erb', Tilt[:erubis]

before do
  DB = Sequel.connect(
    [
      settings.db_type,'://', 
      settings.db_username,':',
      settings.db_password,'@', 
      settings.db_host, ':', 
      settings.db_port, '/', 
      settings.db_name
  ].join(''))
  require './models'
  @cgi_obj = CGI.new('html4')
end

get '/' do
  set_page_title('Home')
  erubis :index
end

get '/admin' do
  set_page_title('Admin')
  erubis :admin
end

get '/admin/skills' do
    @skills = Skill
    set_page_title('Skills admin')
    erubis :admin_skills
end

get '/admin/skill/new' do
  @skill = Skill.new
  set_page_title('New skill')
  erubis :admin_skill_new
end

get '/admin/skill/edit/:skill_id' do
  begin
    @skill = Skill[params[:skill_id].to_i]
    set_page_title('Edit skill')
    erubis :admin_skill_edit
  rescue Exception => e
    404
    @error = "Couldn't find that skill. #{e}"
    erubis :index
  end
end

post '/admin/skill/create' do
  begin
    skill = Skill.create(
      :name => params[:name],
      :url => params[:url],
      :description => params[:description],
      :skill_level => params[:skill_level].to_i
    )
    skill.save
    redirect '/admin/skills'
  rescue Exception => e
    @error = "There was a problem saving this. Please try again. The database said: #{e}"
    #might need better sanity checks
    @skill = Skill.new(params)
    erubis :admin_skill_new
  end
end

post '/admin/skill/update' do
  begin
    skill = Skill[params[:skill_id].to_i]
    skill.set(
      :name => params[:name],
      :url => params[:url],
      :description => params[:description],
      :skill_level => params[:skill_level].to_i
    )
    skill.save
    redirect '/admin/skills'
  rescue Exception => e
    @error = "There was a problem saving this. Please try again. The database said: #{e.errstr}"
    @skill = [params[:skill_id].to_i,params[:name], params[:url], params[:description], params[:skill_level].to_i]
    erubis :admin_skill_edit
  end
end

get 'skill/:id/:name' do

end
