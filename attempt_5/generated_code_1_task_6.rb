# Pushes the repository to GitHub
def push_to_github
  # Assumes the current directory is the root of the repository
  # Assumes the repository has already been initialized with git
  # Assumes the repository has already been added to GitHub as a remote

  # Run the git command to push the changes to the remote repository
  system('git push origin master')
end
