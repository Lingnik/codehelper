# Initializes a Git repository within a Rails project
def initialize_git_repository
  # Check if the .git folder already exists
  if Dir.exist?(".git")
    puts "Git repository already exists"
  else
    # Initialize a new Git repository
    `git init`
    puts "Git repository initialized"
  end
end
