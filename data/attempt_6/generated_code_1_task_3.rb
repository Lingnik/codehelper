# Initializes a Git repository in the Rails project
def initialize_git_repo
  # Navigate to the root directory of the Rails project
  Dir.chdir(Rails.root)

  # Check if the .git directory already exists
  if Dir.exist?(".git")
    puts "Git repository already exists"
  else
    # Initialize a new Git repository
    `git init`
    puts "Git repository initialized"
  end
end
