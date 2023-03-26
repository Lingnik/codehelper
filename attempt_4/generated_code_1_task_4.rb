# Function name: create_initial_commit
# Inputs: none
# Outputs: none
# Description: This function creates an initial commit with the standard Rails project structure.

def create_initial_commit
  # Initialize a new Git repository in the current directory
  `git init`

  # Add all files to the Git repository
  `git add .`

  # Create an initial commit with a descriptive message
  `git commit -m "Add initial commit with Rails project structure"`
end
