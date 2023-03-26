require_relative 'github_client'
require_relative 'openai_client'

your_username = ARGV[1]
repo_name = ARGV[0]
issue_number = ARGV[2].to_i

api_key = ENV['GITHUB_API_KEY']
gh_client = GitHubClient.new(api_key)

model = ENV.fetch('GPT_MODEL', 'text-davinci-003')
openai_api_key = ENV['OPENAI_API_KEY']
openai_client = OpenAIClient.new(openai_api_key, model)

issue = gh_client.get_issue(your_username, repo_name, issue_number)
issue_title = issue.title
issue_description = issue.body

puts "Issue title:\n#{issue_title}"
puts "Issue description:\n#{issue_description}"

# Split issue description into bullets
bullets = issue_description.split("\n").select { |line| line.start_with?('-') }

bullets.each_with_index do |bullet, index|
  puts "Bullet:\n#{bullet}"
  puts "Index:\n#{index}"

  prompt = "Given a Ruby on Rails project: #{issue_title.downcase}\n\nPlease provide a Ruby file containing a function (aptly-named based on the task) necessary to complete this task:\n> #{bullet.strip}\n\nOmit any explanation, only provide the code. Provide adequate comments in the file, including the project name at the top of the file and the task as a comment on the function."
  
  puts "Prompt: #{prompt}" # Debugging: print the prompt

  code = openai_client.generate_code(prompt)

  puts "Generated code: #{code}" # Debugging: print the generated code

  File.open("generated_code_#{issue_number}_task_#{index + 1}.rb", 'w') do |file|
    file.puts code
  end

  puts "Generated code for issue ##{issue_number} task #{index + 1} saved to generated_code_#{issue_number}_task_#{index + 1}.rb"
end

