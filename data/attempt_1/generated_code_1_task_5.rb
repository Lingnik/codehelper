

#Project Name: Rails Project Structure

#Task: Create a .gitignore file with standard Rails exclusions

def create_gitignore
  File.open(".gitignore", "w") do |f|
    f.puts("# See https://help.github.com/articles/ignoring-files for more about ignoring files.")
    f.puts("# ignore bundler config")
    f.puts("/.bundle")
    f.puts("")
    f.puts("# ignore the default SQLite database")
    f.puts("/db/*.sqlite3")
    f.puts("/db/*
