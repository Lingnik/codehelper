require_relative 'github_client'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: gh_create_repo.rb [options]"

  opts.on('-u', '--username USERNAME', 'Your GitHub username') do |username|
    options[:username] = username
  end

  opts.on('-r', '--repo-name REPO_NAME', 'The name of the repository to create') do |repo_name|
    options[:repo_name] = repo_name
  end
end.parse!

# Initialize the GitHub client
github_client = GitHubClient.new

# Create a new private GitHub repository
repo = github_client.create_repository(options[:repo_name], options[:username])

puts "Created private repository '#{options[:repo_name]}'."
