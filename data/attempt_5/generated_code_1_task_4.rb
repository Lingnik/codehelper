# Adds initial commit with Rails project structure
def add_initial_commit
  # Assuming Git is installed and initialized in the project directory
  # Add all files to the staging area
  `git add .`

  # Create an initial commit with a message
  `git commit -m "Initial commit with Rails project structure"`
end
