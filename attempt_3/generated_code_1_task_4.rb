# This function adds an initial commit with the Rails project structure.
# Assumes that the Rails project has already been created.
def add_initial_commit
  # Navigate to the root directory of the Rails project.
  Dir.chdir("path/to/rails/project")

  # Initialize a Git repository.
  `git init`

  # Add all files to the Git repository.
  `git add .`

  # Commit the changes with a message.
  `git commit -m "Initial commit with Rails project structure"`
end
