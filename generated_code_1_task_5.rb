def create_gitignore_file
  # Define the standard Rails exclusions
  exclusions = %w(
    .bundle
    bin/*
    db/*.sqlite3
    log/*.log
    tmp/**/*
    .byebug_history
    .DS_Store
    .env
    .env.*
    .ruby-gemset
    .ruby-version
    public/system/*
    public/uploads/*
  )

  # Create the .gitignore file and write the exclusions to it
  File.open('.gitignore', 'w') do |f|
    f.puts exclusions
  end
end
