require 'fileutils'

class GitClient

  def clone_repository(username, repo_name)
    repo_url = "git@github.com:#{username}/#{repo_name}.git"
    local_path = "tmp/#{repo_name}"
  
    FileUtils.rm_rf(local_path) if Dir.exist?(local_path)
    FileUtils.mkdir_p(local_path)
  
    system("git clone #{repo_url} #{local_path}")
    local_path
  end
  
  def git_commit(repo_path, commit_message_file_path)
    Dir.chdir(repo_path) do
      `git add .`
      `git reset -- #{commit_message_file_path}`
      `git commit --file=#{commit_message_file_path}`
      `rm #{commit_message_file_path}`
    end
  end

  def git_create_branch(local_repo_path, issue_number)
    Dir.chdir(local_repo_path) do
      system("git checkout -b issue_#{issue_number}")
    end
  end

  def git_push(local_repo_path, issue_number)
    Dir.chdir(local_repo_path) do
      system("git push origin issue_#{issue_number}")
    end
  end

  def commit_and_push(local_repo_path, issue_number, commit_message_file_path)
    git_create_branch(issue_number)
    git_commit(local_repo_path, commit_message_file_path)
    git_push(local_repo_path, issue_number)
  end

end
