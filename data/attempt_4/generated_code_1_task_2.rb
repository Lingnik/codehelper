# Creates a new Rails project
# Assumes that the user has Rails installed on their machine
# @param project_name [String] the name of the new Rails project
# @return [void]
def create_new_rails_project(project_name)
  system("rails new #{project_name}")
end

create_new_rails_project("my_new_project")
