# Pushes the current repository to GitHub
def push_to_github
  # Assumes that the repository has already been initialized with git and linked to a remote GitHub repository
  # Uses the `git push` command to push the current branch to the remote repository
  `git push`
end
