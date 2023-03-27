

# Create a new Rails project
# Task: set up the initial rails project structure

def create_rails_project
  project_name = "MyRailsProject"

  # Create the project directory
  Dir.mkdir(project_name)

  # Change directory to the project directory
  Dir.chdir(project_name)

  # Generate the Rails project
  system("rails new #{project_name}")
end
