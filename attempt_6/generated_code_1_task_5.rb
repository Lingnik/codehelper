def create_gitignore_file
  # Create a new .gitignore file or overwrite the existing one
  File.open('.gitignore', 'w') do |f|
    # Add standard Rails exclusions
    f.puts('*.log')
    f.puts('*.swp')
    f.puts('/tmp')
    f.puts('/log')
    f.puts('/coverage/')
    f.puts('/public/system')
    f.puts('/public/uploads')
    f.puts('/node_modules')
    f.puts('/yarn-error.log')
  end
end
