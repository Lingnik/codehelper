require 'fileutils'

class GitClient

  def clone_repository(username, repo_name)
    repo_url = "https://github.com/#{username}/#{repo_name}.git"
    local_path = "tmp/#{repo_name}"
  
    FileUtils.rm_rf(local_path) if Dir.exist?(local_path)
    FileUtils.mkdir_p(local_path)
  
    system("git clone #{repo_url} #{local_path}")
    local_path
  end
  
  def push_to_remote_repository(local_repo_path, issue_number)
    Dir.chdir(local_repo_path) do
      system("git checkout -b issue_#{issue_number}")
      system("git add .")
      system("git commit -m 'Add generated code for issue ##{issue_number}'")
      system("git push origin issue_#{issue_number}")
    end
  end

end
