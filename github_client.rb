require 'octokit'
require 'json'

##
# The GitHubClient class provides an interface for interacting with the GitHub API.
class GitHubClient
  ##
  # Initializes a new instance of the GitHubClient class.
  #
  # @param [String] access_token The GitHub access token to use for authentication.
  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
  end

  ##
  # Retrieves the authenticated user.
  #
  # @return [Sawyer::Resource] The authenticated user.
  def get_authenticated_user
    @client.user
  end

  ##
  # Creates a new repository.
  #
  # @param [String] repo_name The name of the repository to create.
  # @param [String] your_username The username of the user creating the repository.
  # @param [Boolean] private_repo A boolean value indicating whether the repository should be private or public.
  # @return [Sawyer::Resource] The newly created repository.
  def create_repository(repo_name, your_username, private_repo = true)
    @client.create_repository(repo_name, owner: your_username, private: private_repo)
  end

  ##
  # Creates issues for a given repository.
  #
  # @param [String] repo_full_name The full name of the repository to create issues for.
  # @param [Array<String>] issue_titles An array of issue titles to create.
  def create_issues(repo_full_name, issue_titles)
    existing_issues = fetch_existing_issue_titles(repo_full_name)

    issue_titles.each_with_index do |title, index|
      next if existing_issues.include?(title)
      
      create_issue_with_retry(repo_full_name, title)
      puts "Created issue ##{index + 1}: '#{title}'."
    end
  end

  ##
  # Updates an issue in a given repository.
  #
  # @param [String] repo_full_name The full name of the repository containing the issue.
  # @param [Integer] issue_number The number of the issue to update.
  # @param [String] title The new title for the issue.
  # @param [String] description The new description for the issue.
  def update_issue(repo_full_name, issue_number, title, description)
    @client.update_issue(repo_full_name, issue_number, title: title, body: description)
  end

  ##
  # Retrieves an issue from a given repository.
  #
  # @param [String] owner The owner of the repository.
  # @param [String] repo The name of the repository.
  # @param [Integer] issue_number The number of the issue to retrieve.
  # @return [Sawyer::Resource] The retrieved issue.
  def get_issue(owner, repo, issue_number)
    @client.issue("#{owner}/#{repo}", issue_number)
  end

  ##
  # Retrieves issues from a given repository.
  #
  # @param [String] repo_full_name The full name of the repository to retrieve issues from.
  # @param [String] state The state of the issues to retrieve.
  # @return [Array<Sawyer::Resource>] An array of issues.
  def get_issues(repo_full_name, state: 'open')
    @client.issues(repo_full_name, state: state)
  end

  ##
  # Retrieves approved issues from a given repository.
  #
  # @param [String] repo_full_name The full name of the repository to retrieve issues from.
  # @param [String] tag The tag to filter the issues.
  # @return [Array<Sawyer::Resource>] An array of issues.
  def get_approved_issues(repo_full_name, tag = 'approved-for-codehelper')
    @client.issues(repo_full_name, labels: tag)
  end

  ##
  # Deletes the specified branch from the repository.
  #
  # @param [String] repo_full_name The full name of the repository (e.g., "username/repo").
  # @param [String] branch The name of the branch to delete.
  def delete_branch(repo_full_name, branch)
    @client.delete_branch(repo_full_name, branch)
  end

  ##
  # Creates a pull request on the specified repository.
  #
  # @param [String] repo_full_name The full name of the repository (e.g., "username/repo").
  # @param [String] head_branch The name of the branch you want to merge into the base branch.
  # @param [String] base_branch The name of the branch you want your changes pulled into.
  # @param [String] title The title of the pull request.
  # @return [Sawyer::Resource] The newly created pull request.
  def create_pull_request(repo_full_name, head_branch, base_branch, title)
    @client.create_pull_request(repo_full_name, base_branch, head_branch, title)
  end

  ##
  # Creates a pull request for the specified issue on the specified repository.
  #
  # @param [String] repo The name of the repository.
  # @param [Integer] issue_number The issue number.
  # @param [String] base The name of the branch you want your changes pulled into.
  # @param [String] head The name of the branch you want to merge into the base branch.
  # @param [Integer] retries The maximum number of retries if the request fails (default: 5).
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

  ##
  # Fetches the existing issue titles for a given repository.
  #
  # @param [String] repo_full_name The full name of the repository.
  # @return [Array<String>] The existing issue titles.
  def fetch_existing_issue_titles(repo_full_name)
    existing_issues = @client.list_issues(repo_full_name, state: 'all')
    existing_issues.map(&:title)
  end

  ##
  # Creates an issue for a given repository with retry functionality in case of a rate limit error.
  #
  # @param [String] repo_full_name The full name of the repository.
  # @param [String] title The title of the issue.
  # @param [Integer] max_retries The maximum number of retries to attempt.
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

