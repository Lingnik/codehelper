# Get a list of all files in the current directory that match *.rb
files = Dir.glob("*.rb")

# Iterate over the files and print the filename, contents, and newlines for each
files.each do |file|
  puts "# File: #{file}"
  puts File.read(file)
  puts "\n\n"
end
