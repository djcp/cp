set :sql, {
  :insert_skill => %Q|INSERT into skills
  (name, url, description, skill_level)
  VALUES(?,?,?,?)
  |,
  :get_skill => %Q|SELECT * from skills where skill_id = ?|,
  :get_skills => %Q|SELECT * from skills|,
  :update_skill => %Q|UPDATE skills set name = ?, url = ?, description = ?, skill_level = ? where skill_id = ?|
}
