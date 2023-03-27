require_relative 'github_client'
require_relative 'gh_generate_code_from_issue'
require_relative 'openai_client'
require_relative 'git_client'
require 'fileutils'


def auto_generate_code(github_api_key, your_username, repo_name)
  full_repo_name = "#{your_username}/#{repo_name}"

  git_client = GitClient.new
  puts "Cloning repository..."
  local_repo_path = git_client.clone_repository(your_username, repo_name)

  gh_client = GitHubClient.new(github_api_key)
  puts "Getting approved issues..."
  approved_issues = gh_client.get_approved_issues(full_repo_name)

  if approved_issues.empty?
    puts "No approved issues found for the repository #{full_repo_name}. Nothing to do."
  else
    approved_issues.each do |issue|
      issue_number = issue[:number]
      puts "Generating code for approved issue ##{issue_number}..."

      branch_name = "issue_#{issue_number}"
      commit_summary_file_path = generate_code_from_issue(your_username, repo_name, issue_number, local_repo_path)
      gh_client.delete_branch(full_repo_name, branch_name)
      git_client.commit_and_push(local_repo_path, issue_number, commit_message_file_path)
      gh_client.create_pull_request_for_issue(full_repo_name, issue_number, "main", branch_name)
    end
  end
end

if __FILE__ == $0
  api_key = ENV['GITHUB_API_KEY']
  git_client = GitClient.new
  gh_client = GitHubClient.new(api_key)
  authenticated_user = gh_client.get_authenticated_user
  your_username = authenticated_user.login
  repo_name = ARGV[0]

  auto_generate_code(api_key, your_username, repo_name)
end
