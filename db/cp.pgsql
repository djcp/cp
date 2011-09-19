
drop table skills;

create table skills(
  skill_id serial not null, 
  name varchar(1024) not null,
  url varchar(512), 
  description text, 
  skill_level integer
);

CREATE UNIQUE INDEX skill_name on skills(name);

drop table projects;

create table projects(
  project_id serial not null, 
  name varchar(1024), 
  url varchar(512), 
  source_code varchar(512),
  summary varchar(1024),
  description text,
  project_date timestamp without time zone

  
  
);

drop table projects_screenshots;

create table projects_screenshots(
  project_screenshot_id serial not null,
  path varchar(512) not null
);
