def create_new_rails_project(project_name)
  # Create a new Rails project with the given name
  system("rails new #{project_name}")

  # Change directory to the new project directory
  Dir.chdir(project_name)

  # Initialize a new Git repository
  system("git init")

  # Add all files to the Git repository
  system("git add .")

  # Create an initial commit with the project structure
  system("git commit -m 'Initial commit with Rails project structure'")
end
