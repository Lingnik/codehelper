require_relative 'github_client'
require_relative 'gh_generate_code_from_issue'

your_username = ARGV[0]
repo_name = ARGV[1]

api_key = ENV['GITHUB_API_KEY']
gh_client = GitHubClient.new(api_key)

approved_issues = gh_client.get_approved_issues("#{your_username}/#{repo_name}")

approved_issues.each do |issue|
  issue_number = issue[:number]
  puts "Generating code for approved issue ##{issue_number}..."
  generate_code_from_issue(your_username, repo_name, issue_number)
end
