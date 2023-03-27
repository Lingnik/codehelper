# Creates a new Rails project
# Assumes that Rails is installed on the system
# and that the user has the necessary permissions to create a new project
def create_new_rails_project(project_name)
  system("rails new #{project_name}")
end
