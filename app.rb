require 'rubygems'
require 'sinatra'
require 'dbi'
require 'erubis'
require 'init'
require 'helpers'
require 'cgi'

Tilt.register 'html.erb', Tilt[:erubis]

before do
  begin
    dbh = DBI.connect(['DBI', 
      settings.db_type,
      settings.db_name,
      settings.db_host,
      ].join(':'),
      settings.db_username,
      settings.db_password
    )
  rescue DBI::DatabaseError => e
  'Oops. DB fail.'
  end
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
  set_page_title('Skills admin')
  erubis :admin_skills
end

get '/admin/skill/new' do
  set_page_title('New skill')
  @form = @cgi_obj.form('post', url('admin/skill/create')) do
    @cgi_obj.fieldset() do
      '<legend>New Skill</legend>' + 
      '<div>' + 
      @cgi_obj.label('for' => 'skill_name'){'Skill'} +
      @cgi_obj.text_field('name' => 'name', 'id' => 'skill_name', 'size' => '50') + 
      "</div>" +  
      "<div>" + 
      @cgi_obj.label('for' => 'skill_url'){"Canonical link for skill - e.g. for ruby you'd link to ruby-lang.org"} +
      @cgi_obj.text_field('name' => 'url', 'id' => 'skill_url', 'size' => '100') + 
      "</div>" +
      '<div class="textarea">' + 
      @cgi_obj.label('for' => 'skill_description'){'Description'} + 
      @cgi_obj.textarea('name' => 'description', 'id' => 'skill_description') + 
      '</div>' +
      '<div>' + 
      @cgi_obj.label('for' => 'skill_skill_level'){'Skill level'} + 
      @cgi_obj.text_field('name' => 'skill_level', 'id' => 'skill_skill_level') + 
      '</div>' +
      '<div>' +
      @cgi_obj.submit('New Skill') + 
      '</div>'
    end
  end
  erubis :admin_skill_new
end

post '/admin/skill/create' do

end

