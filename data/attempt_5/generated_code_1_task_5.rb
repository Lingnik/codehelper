def create_gitignore
  # Define the standard Rails exclusions
  exclusions = [
    '.bundle',
    'log/*',
    'tmp/**/*',
    'vendor/bundle',
    'public/system',
    'public/uploads'
  ]

  # Create the .gitignore file and write the exclusions to it
  File.open('.gitignore', 'w') do |file|
    exclusions.each do |exclusion|
      file.puts exclusion
    end
  end
end
