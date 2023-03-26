require_relative 'github_client'
require 'json'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: gh_create_issues.rb [options]"

  opts.on('-u', '--username USERNAME', 'Your GitHub username') do |username|
    options[:username] = username
  end

  opts.on('-r', '--repo-name REPO_NAME', 'The name of the repository to create issues in') do |repo_name|
    options[:repo_name] = repo_name
  end
end.parse!

# Initialize the GitHub client
github_client = GitHubClient.new

# Repository's full name
repo_full_name = "#{options[:username]}/#{options[:repo_name]}"

# Read the list of issues from the 'seed_issues.json' file in the same directory
file_path = File.join(__dir__, 'seed_issues.json')
issue_titles = JSON.parse(File.read(file_path))

# Create GitHub issues for each title in the JSON data
github_client.create_issues(repo_full_name, issue_titles)

puts "Created #{issue_titles.length} issues in the '#{repo_full_name}' repository."
