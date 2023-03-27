require_relative 'github_client'
require_relative 'openai_client'

# Read project directory structure
def get_project_files_and_contents(path)
  files_and_contents = {}

  Dir.glob("#{path}/**/*") do |file|
    next if File.directory?(file)

    relative_file_path = file.gsub("#{path}/", '')
    file_contents = File.read(file)
    files_and_contents[relative_file_path] = file_contents
  end

  files_and_contents
end

# Summarize the reasons for a collection of file changes as a git commit.
def summarize_reasoning_to_commit(reasonings, openai_client, issue_number)
  messages = [
    {
      role: "system",
      content: <<-PROMPT
You are an AI language model that takes an array of file change explanations and generates a summary in the form of a commit message in the format of a ≤50-character title, a blank line, a summary in bulleted form, a blank line, and the message "Fixes ##{issue_number}". Your response should be concise and informative.
      PROMPT
    },
    {
      role: "user",
      content: "Generate a summary commit message for the following file change explanations:\n\n#{reasonings.join("\n\n")}"
    }
  ]

  summary_response = openai_client.generate_response(messages)
  summary = summary_response.strip
  return summary
end

def generate_code_from_issue(your_username, repo_name, issue_number, local_repo_path)
  api_key = ENV['GITHUB_API_KEY']
  gh_client = GitHubClient.new(api_key)

  model = ENV.fetch('GPT_MODEL', 'gpt-3.5-turbo')
  openai_api_key = ENV['OPENAI_API_KEY']
  openai_client = OpenAIClient.new(openai_api_key, model)

  issue = gh_client.get_issue(your_username, repo_name, issue_number)
  issue_title = issue.title
  issue_description = issue.body

  # Get project files and contents
  files_and_contents = get_project_files_and_contents(local_repo_path)

  messages = [
    {
      role: "system",
      content: <<-PROMPT
You are a helpful autonomous programming agent that responds in a specified JSON format containing a list of code changes as requested in a GitHub issue, within the context of an existing project structure, both of which the user provides.

## Design Objectives

* Write code that is secure and free of defects.
* Write code that is concise, simple, and easy-to-read. Include helpful, descriptive comments when this is not possible.
* Write code that meets all of the objectives of the GitHub issue.
* Write code that integrates with the existing functionality of the system.
* Maintain the existing functionality of the overall system, unless instructed to remove or alter existing functionality. 
* Maintain the existing programming language choices and coding styles, unless the objective of the issue is to refactor them.
* Maintain the existing structure and layout of code, unless the objective of the issue is to refactor the structure and layout of code.
* Maintain the existing structure and layout of the project files, unless the objective of the issue is to refactor the structure or layout of the project files.
* Otherwise use industry best practices when writing code.

## Request Format

You will be provided a markdown-formatted prompt:
1. Describing your objective
2. Containing the text of the actual GitHub Issue
3. And containing a code block of a JSON-formatted collection of files and their contents representing the existing project

## Response Format

Your response must conform to the format in this section. The format should be JSON. The JSON will contain an array of files that need to be created or modified. Each file will be represented as a dictionary. The final line of your response should be `###END###`. The template follows:

```
{
  'files: [
    {'file_name': '<file_path>', 'action': '[create|modify]', 'code': '<generated_code>', 'reasoning': '<explanation>'},
  ]
}
###END###
```

### Response Fields

Here are descriptions of each field in the file dictionary.

* file_name: The full file path for the file, conforming to existing names and paths in the Existing Code Structure.
* action: `create` if creating a new file, `modify` if modifying an existing file. The array may contain files with actions of different types.
* code: The full contents of the file.
* reasoning: A concise, human-readable explanation of the reasoning for the change. The explanation should be a title on its own line, no longer than 50 characters, followed by a blank line, followed by no more than ten bulleted statements no longer than 72 characters long.

### Example Responses

For example, if a new file needs to be created, the file's output should look like:

```
{'file_name': 'new_file.rb', 'action': 'create', 'code': 'def new_method\n  # code here\nend', 'reasoning': 'explanation here'}
```

For example, if an existing file needs to be modified, the file's output should look like:

```
{'file_name': 'existing_file.rb', 'action': 'modify', 'code': 'def modified_method\n  # updated code here\nend', 'reasoning': 'explanation here'}
```

For example, the `reasoning` field might look like this:

```
calculate pi to fifty digits

* calculates pi to fifty digits
* avoids use of math to do so
* known bug: creates a black hole when 49th digit is computed 
* we chose this approach because it is efficient
* we regret our decisions 
```
      PROMPT
    },
    {
      "role": "user",
      content: <<-PROMPT
## Prompt Goal
Please generate code to implement the specified improvement based on the provided GitHub Issue and Existing Code Structure. 

## GitHub Issue
Title: '#{issue_title}'
Description:
```
#{issue_description}
```

## Existing Code Structure
Here is the current code structure:
```
#{files_and_contents}
```

      PROMPT
    }
  ]

  response = openai_client.generate_response(messages)
  generated_code_info = JSON.parse(response)

  # Process the generated code information according to the format in the prompt
  git_client = GitClient.new
  reasonings = []
  
  generated_code_info['files'].each do |file_info|
    file_name = file_info['file_name']
    action = file_info['action']
    code = file_info['code']
    reasoning = file_info['reasoning']

    file_path = File.join(local_repo_path, file_name)

    File.write(file_path, code)

    reasonings << reasoning
  end

  puts "Generated code for issue ##{issue_number}"

  commit_summary = summarize_reasoning_to_commit(reasonings, openai_client, issue_number)
  commit_summary_file_path = File.join(local_repo_path, "commit_summary.txt")
  File.write(commit_summary_file_path, commit_summary)
  puts "Commit summary saved to: #{commit_summary_file_path}"

  return commit_summary_file_path
end

if __FILE__ == $0
  your_username = ARGV[0]
  repo_name = ARGV[1]
  issue_number = ARGV[2].to_i
  generate_code_from_issue(your_username, repo_name, issue_number)
end
