# Initializes a Git repository in the current Rails project
def initialize_git_repository
  # Navigate to the root directory of the Rails project
  Dir.chdir(Rails.root)

  # Check if the .git directory exists
  if !File.directory?(".git")
    # If it doesn't exist, initialize a new Git repository
    `git init`
    puts "Git repository initialized"
  else
    puts "Git repository already exists"
  end
end
