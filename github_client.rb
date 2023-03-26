require 'octokit'
require 'json'

class GitHubClient
  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
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

