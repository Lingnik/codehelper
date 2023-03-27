require_relative 'github_client'
require_relative 'gh_generate_code_from_issue'
require_relative 'openai_client'
require_relative 'git_client'
require 'fileutils'


def generate_script_file(issue_title, file_paths)
  script_file_name = issue_title.split.join("_").downcase + "_script.rb"
  code = file_paths.map { |path| File.read(path) }.join("\n")
  prompt = <<-PROMPT
#{code}

Please provide a script to run all the functions in the correct order to complete the '#{issue_title}' task.
  PROMPT

  script = @openai_client.generate_code(prompt, max_tokens = 2048, n = 1, stop = "\n", temperature = 0.5, max_attempts = 5)

  File.write(script_file_name, script)
  puts "Generated script file '#{script_file_name}'"
end

def auto_generate_code(github_api_key, your_username, repo_name)
  full_repo_name = "#{your_username}/#{repo_name}"

  git_client = GitClient.new
  local_repo_path = git_client.clone_repository(your_username, repo_name)

  gh_client = GitHubClient.new(github_api_key)
  approved_issues = gh_client.get_approved_issues(full_repo_name)

  approved_issues.each do |issue|
    issue_number = issue[:number]
    branch_name = "issue_#{issue_number}"
    puts "Generating code for approved issue ##{issue_number}..."
    generate_code_from_issue(your_username, repo_name, issue_number, local_repo_path)
    gh_client.delete_branch(full_repo_name, branch_name)
    git_client.push_to_remote_repository(local_repo_path, issue_number)
    gh_client.create_pull_request_for_issue(full_repo_name, issue_number, "main", branch_name)
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
