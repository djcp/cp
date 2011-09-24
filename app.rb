$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))
require 'rubygems'
require 'sinatra'
require 'dbi'
require 'erubis'
require 'init'
require 'helpers'
require 'cgi'
require 'partials'
require 'sql_statements'
# set :erubis, :escape_html => true

set :environment, :development

helpers Sinatra::Partials

Tilt.register 'html.erb', Tilt[:erubis]

before do
  @dbh = DBI.connect(['DBI', 
    settings.db_type,
    settings.db_name,
    settings.db_host,
    ].join(':'),
    settings.db_username,
    settings.db_password
  )
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
  begin
    @skills = @dbh.select_all(settings.sql[:get_skills])
    set_page_title('Skills admin')
    erubis :admin_skills
  rescue DBI::DatabaseError => e
  end
end

get '/admin/skill/new' do
  @skill = []
  set_page_title('New skill')
  erubis :admin_skill_new
end

get '/admin/skill/edit/:skill_id' do
  begin
    @skill = @dbh.select_one(settings.sql[:get_skill],params[:skill_id])
    if @skill.nil?
      raise DBI::DatabaseError.new('Not found.')
    end
    $stderr.puts @skill.inspect
    set_page_title('Edit skill')
    erubis :admin_skill_edit
  rescue DBI::DatabaseError => e
    404
    @error = "Couldn't find that skill. #{e.errstr}"
    erubis :index
  end
end

post '/admin/skill/create' do
  begin
    sth = @dbh.prepare(settings.sql[:insert_skill])
    sth.execute(
      params[:name],
      params[:url],
      params[:description],
      params[:skill_level].to_i
    )
    redirect '/admin/skills'
  rescue DBI::DatabaseError => e
    @error = "There was a problem saving this. Please try again. The database said: #{e.errstr}"
    @skill = [0,params[:name], params[:url], params[:description], params[:skill_level].to_i]
    erubis :admin_skill_new
  end
end

post '/admin/skill/update' do
  begin
    sth = @dbh.prepare(settings.sql[:update_skill])
    sth.execute(
      params[:name],
      params[:url],
      params[:description],
      params[:skill_level].to_i,
      params[:skill_id].to_i
    )
    redirect '/admin/skills'
  rescue DBI::DatabaseError => e
    @error = "There was a problem saving this. Please try again. The database said: #{e.errstr}"
    @skill = [params[:skill_id].to_i,params[:name], params[:url], params[:description], params[:skill_level].to_i]
    erubis :admin_skill_edit
  end
end

get 'skill/:id/:name' do

end
