# Adds initial commit with Rails project structure
def add_initial_commit
  # Assuming that the project has already been created using "rails new" command
  # and the current working directory is the root of the project
  `git init`
  `git add .`
  `git commit -m "Initial commit with Rails project structure"`
end
