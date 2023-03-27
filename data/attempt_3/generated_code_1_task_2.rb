# Creates a new Rails project with the given name
# Assumes that the Rails gem is already installed
def create_new_rails_project(project_name)
  system("rails new #{project_name}")
end
