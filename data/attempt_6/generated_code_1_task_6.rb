# Pushes the repository to GitHub.
# Assumes the repository has already been initialized and a remote named "origin" has been set up.
# Assumes the user has already authenticated with GitHub via SSH or HTTPS.
def push_to_github
  system("git push origin master")
end
