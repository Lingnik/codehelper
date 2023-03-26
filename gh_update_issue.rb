# gh_update_issue.rb

require_relative 'github_client'
require 'json'

if ARGV.length < 3
  puts "Usage: ruby gh_update_issue.rb <repo_name> <your_username> <issue_number>"
  exit(1)
end

repo_name = ARGV[0]
your_username = ARGV[1]
issue_number = ARGV[2].to_i
repo_full_name = "#{your_username}/#{repo_name}"

github_client = GitHubClient.new

json_file_path = 'seed_issue_1.json'
data = JSON.parse(File.read(json_file_path))

title = data['title']
description = data['description'].map { |step| "- #{step}" }.join("\n")

github_client.update_issue(repo_full_name, issue_number, title, description)
puts "Issue ##{issue_number} has been updated."
