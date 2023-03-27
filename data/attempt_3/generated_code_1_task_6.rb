# Pushes the local repository to GitHub
def push_to_github
  # Assumes that the current directory is the root of the repository
  # Assumes that the repository has already been initialized with git and connected to GitHub
  # Assumes that the user has permission to push to the repository on GitHub
  system("git push origin master") # Pushes the master branch to the origin remote (assumes that the remote is named "origin")
end
