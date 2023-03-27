# Initializes a Git repository in the root directory of the Rails project.
# Assumes that Git is installed on the system.
def initialize_git_repository
  `git init` # execute git init command
end
