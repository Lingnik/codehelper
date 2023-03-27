require 'octokit'

# Function to push a repository to GitHub
def push_to_github
  # Set up the Octokit client with authentication credentials
  client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

  # Get the current repository information
  repo = client.repository("#{ENV['GITHUB_USERNAME']}/#{ENV['GITHUB_REPO']}")

  # Push the repository to GitHub
  client.create_ref(repo[:full_name], 'heads/master', repo[:default_branch])
  client.push(repo[:full_name], 'master')
end
