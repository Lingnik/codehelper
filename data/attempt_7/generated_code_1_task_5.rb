def create_gitignore_file
  # Define the standard Rails exclusions
  exclusions = %w(
    .bundle
    bin/
    log/
    tmp/
    vendor/
    .byebug_history
    .DS_Store
    .env
    .env.*
    .ruby-version
    Gemfile.lock
    node_modules/
  )

  # Create the .gitignore file and write the exclusions to it
  File.open(".gitignore", "w") do |file|
    exclusions.each do |exclusion|
      file.puts exclusion
    end
  end
end
