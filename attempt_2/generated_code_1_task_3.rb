Here's a Ruby function to initialize a Git repository in a Ruby on Rails project:

```ruby
# Initializes a Git repository in the current Rails project directory.
# Assumes that Git is installed on the system.
def initialize_git_repository
  `git init`
end
```

This function simply calls the `git init` command using backticks to execute it in the terminal. It assumes that Git is installed on the system and that the current working directory is the root of the Rails project.
