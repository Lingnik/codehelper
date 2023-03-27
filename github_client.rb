require 'octokit'
require 'json'

class GitHubClient
  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
  end

  def get_authenticated_user
    @client.user
  end

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

  def get_approved_issues(repo_full_name, tag = 'approved-for-codehelper')
    @client.issues(repo_full_name, labels: tag)
  end

  def delete_branch(repo_full_name, branch)
    @client.delete_branch(repo_full_name, branch)
  end

  def create_pull_request(repo_full_name, head_branch, base_branch, title)
    @client.create_pull_request(repo_full_name, base_branch, head_branch, title)
  end

  def create_pull_request_for_issue(repo, issue_number, base, head, retries = 5)
    begin
      pull_request = @client.create_pull_request_for_issue(repo, base, head, issue_number)
      puts "Created pull request #{pull_request.number}"
    rescue Octokit::UnprocessableEntity => e
      if retries > 0
        sleep_time = 2 ** (5 - retries) # 2^(5 - retries) for logarithmic backoff
        puts "Error creating pull request. Retrying in #{sleep_time} seconds..."
        sleep(sleep_time)
        create_pull_request_for_issue(repo, issue_number, base, head, retries - 1)
      else
        puts "Failed to create pull request after #{retries} attempts."
        puts e.message
      end
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

