# Initializes a Git repository in the Rails project
def initialize_git_repository
  # Check if Git is installed
  if `which git`.empty?
    puts "Git is not installed. Please install Git to use this function."
    return
  end

  # Check if the project directory is a Git repository
  if system("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
    puts "The project directory is already a Git repository."
    return
  end

  # Initialize a new Git repository
  system("git init")

  puts "Git repository initialized."
end
