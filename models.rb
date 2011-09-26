class Skill < Sequel::Model

  def validate
    super
    errors.add(:name, "can't be empty") if name.empty?
    if ! url.empty? && ! url.match(/https?:\/\/.+/i)
      errors.add(:url, "doesn't look right - please be sure it begins with http://") 
    end
  end

end

class ProjectSkill < Sequel::Model

end

class Project < Sequel::Model
end

class ProjectImage < Sequel::Model
end

