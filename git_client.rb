require 'fileutils'

##
# The GitClient class provides an interface for interacting with Git repositories.
#
# This class provides several methods for cloning repositories, committing changes, creating and pushing branches, 
# and committing and pushing changes.
#
# Example usage:
#     client = GitClient.new
#     repo_path = client.clone_repository(username, repo_name)
#     client.commit_and_push(repo_path, issue_number, commit_message_file_path)
class GitClient

  ##
  # Clones a Git repository from GitHub to a local directory.
  #
  # @param [String] username The owner of the repository.
  # @param [String] repo_name The name of the repository.
  #
  # @return [String] The path to the local repository.
  def clone_repository(username, repo_name)
    repo_url = "git@github.com:#{username}/#{repo_name}.git"
    local_path = "tmp/#{repo_name}"
  
    FileUtils.rm_rf(local_path) if Dir.exist?(local_path)
    FileUtils.mkdir_p(local_path)
  
    system("git clone #{repo_url} #{local_path}")
    local_path
  end
  
  ##
  # Commits changes to a Git repository.
  #
  # @param [String] repo_path The path to the local repository.
  # @param [String] commit_message_file_path The path to the file containing the commit message.
  def git_commit(repo_path, commit_message_file_path)
    Dir.chdir(repo_path) do
      `git add .`
      `git reset -- #{commit_message_file_path}`
      `git commit --file=#{commit_message_file_path}`
      `rm #{commit_message_file_path}`
    end
  end

  ##
  # Creates a new Git branch for a given issue number.
  #
  # @param [String] local_repo_path The path to the local repository.
  # @param [String] issue_number The issue number.
  def git_create_branch(local_repo_path, issue_number)
    Dir.chdir(local_repo_path) do
      system("git checkout -b issue_#{issue_number}")
    end
  end

  ##
  # Pushes changes to a Git repository.
  #
  # @param [String] local_repo_path The path to the local repository.
  # @param [String] issue_number The issue number.
  def git_push(local_repo_path, issue_number)
    Dir.chdir(local_repo_path) do
      system("git push origin issue_#{issue_number}")
    end
  end

  ##
  # Commits and pushes changes to a Git repository.
  #
  # @param [String] local_repo_path The path to the local repository.
  # @param [String] issue_number The issue number.
  # @param [String] commit_message_file_path The path to the file containing the commit message.
  def commit_and_push(local_repo_path, issue_number, commit_message_file_path)
    git_create_branch(issue_number)
    git_commit(local_repo_path, commit_message_file_path)
    git_push(local_repo_path, issue_number)
  end

end
