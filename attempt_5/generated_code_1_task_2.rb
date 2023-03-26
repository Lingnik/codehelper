def create_new_rails_project(project_name)
  # This function creates a new Rails project with the given name
  # Assumes that Rails is installed on the system

  system("rails new #{project_name}")
end
