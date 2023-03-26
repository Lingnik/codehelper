require_relative 'github_client'
require_relative 'openai_client'

your_username = ARGV[1]
repo_name = ARGV[0]
issue_number = ARGV[2].to_i

api_key = ENV['GITHUB_API_KEY']
gh_client = GitHubClient.new(api_key)

model = ENV.fetch('GPT_MODEL', 'gpt-3.5-turbo')
openai_api_key = ENV['OPENAI_API_KEY']
openai_client = OpenAIClient.new(openai_api_key, model)

issue = gh_client.get_issue(your_username, repo_name, issue_number)
issue_title = issue.title
issue_description = issue.body

# Split issue description into list items with hyphens
list_items = issue_description.split("\n").select { |line| line.start_with?('-') }

list_items.each_with_index do |item, index|
  prompt = <<-PROMPT
Generate a Ruby function to accomplish the following task in a Ruby on Rails project:

Task: #{item.strip}

Context:
- This function is part of a larger Rails project.
- The project follows standard Rails conventions.

Requirements:
- The function should be written in Ruby.
- The function should have a descriptive name based on the task.
- Include comments to explain the purpose of the function and any assumptions made.

Example Input: (if applicable)
- ...

Example Output: (if applicable)
- ...

Please provide the Ruby function to accomplish this task.
  PROMPT

  code = openai_client.generate_code(prompt)

  File.open("generated_code_#{issue_number}_task_#{index + 1}.rb", 'w') do |file|
    file.puts code
  end

  puts "Generated code for issue ##{issue_number} task #{index + 1} saved to generated_code_#{issue_number}_task_#{index + 1}.rb"
end
