require 'octokit'
require 'json'

class GitHubClient
  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
  end


  # GitHub operations
  def create_repository(repo_name, your_username, private_repo = true)
    @client.create_repository(repo_name, owner: your_username, private: private_repo)
  end

  def create_issues(repo_full_name, issue_titles)
    existing_issues = fetch_existing_issue_titles(repo_full_name)

    issue_titles.each_with_index do |title, index|
      next if existing_issues.include?(title)
      
      create_issue_with_retry(repo_full_name, title)
      puts "Created issue ##{index + 1}: '#{title}'."
    end
  end

  def update_issue(repo_full_name, issue_number, title, description)
    @client.update_issue(repo_full_name, issue_number, title: title, body: description)
  end

  def get_issue(owner, repo, issue_number)
    @client.issue("#{owner}/#{repo}", issue_number)
  end

  def get_issues(repo_full_name, state: 'open')
    @client.issues(repo_full_name, state: state)
  end

  def get_approved_issues(repo_full_name, tag = 'approved')
    @client.issues(repo_full_name, labels: tag)
  end

  def create_pull_request(repo_full_name, head_branch, base_branch, title)
    @client.create_pull_request(repo_full_name, base_branch, head_branch, title)
  end


  # Local git operations
  def clone_repository(repo_full_name, local_repo_path)
    system("git clone https://github.com/#{repo_full_name}.git #{local_repo_path}")
  end

  def create_branch(local_repo_path, branch_name)
    Dir.chdir(local_repo_path) do
      system("git checkout -b #{branch_name}")
    end
  end

  def commit_changes(local_repo_path, commit_message)
    Dir.chdir(local_repo_path) do
      system("git add .")
      system("git commit -m '#{commit_message}'")
    end
  end

  def push_branch(local_repo_path, your_username, repo_name, branch_name)
    Dir.chdir(local_repo_path) do
      system("git push --set-upstream https://#{api_key}@github.com/#{your_username}/#{repo_name}.git #{branch_name}")
    end
  end



  private

  def fetch_existing_issue_titles(repo_full_name)
    existing_issues = @client.list_issues(repo_full_name, state: 'all')
    existing_issues.map(&:title)
  end

  def create_issue_with_retry(repo_full_name, title, max_retries = 5)
    retries = 0
    begin
      @client.create_issue(repo_full_name, title)
    rescue Octokit::TooManyRequests => e
      if retries < max_retries
        sleep_time = 2**(retries + 1)
        puts "Hit rate limit. Retrying in #{sleep_time} seconds..."
        sleep(sleep_time)
        retries += 1
        retry
      else
        puts "Reached the maximum number of retries. Please try again later."
        exit(1)
      end
    end
  end
end

