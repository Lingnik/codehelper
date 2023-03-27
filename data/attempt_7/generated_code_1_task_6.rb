# This function pushes the repository to GitHub
# Assumes that the repository has already been set up on GitHub and that the user has the necessary permissions to push to the repository
def push_to_github
  system('git remote add origin https://github.com/username/repo.git') # add the GitHub repository as a remote
  system('git push -u origin master') # push the changes to the GitHub repository
end
