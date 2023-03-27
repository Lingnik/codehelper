Here's a Ruby function that creates a .gitignore file with standard Rails exclusions:

```ruby
def create_gitignore_file
  # Define the standard Rails exclusions
  exclusions = %w(
    .bundle
    /db/*.sqlite3*
    /log/*
    /tmp/*
    /node_modules
    /public/assets
    /public/packs
    /public/packs-test
    /public/system
    /yarn-error.log
    /coverage/
    /spec/tmp/*
  )

  # Create the .gitignore file and add the exclusions
  File.open('.gitignore', 'w') do |file|
    exclusions.each do |exclusion|
      file.puts exclusion
