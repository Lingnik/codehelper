require 'fileutils'
require 'ripper'
require_relative 'openai_client'

def extract_code_information(code)
  parsed_code = Ripper.sexp(code)

  classes_and_methods = []

  parsed_code.each do |node|
    if node[1] == :class || node[1] == :module
      class_name = node[2][1][1]
      class_methods = []

      node[3].each do |method_node|
        if method_node[1] == :def
          method_name = method_node[2]
          class_methods << method_name
        end
      end

      classes_and_methods << { name: class_name, type: node[1], methods: class_methods }
    end
  end

  classes_and_methods
end

def generate_method_summary(code, openai_client)
  messages = [
    { role: "system", content: "I am a helpful assistant trained to provide summaries and explanations for Ruby code." },
    { role: "user", content: "Summarize this Ruby code: ```ruby\n#{code}\n```" }
  ]

  response = openai_client.generate_response(messages, max_tokens = 1000, n = 1, stop = nil, temperature = 0.5, max_attempts = 5)
  response.strip
end

def generate_documentation(file_path, output_directory = 'docs')
  code = File.read(file_path)
  code_info = extract_code_information(code)

  model = ENV.fetch('GPT_MODEL', 'gpt-3.5-turbo')
  openai_api_key = ENV['OPENAI_API_KEY']
  openai_client = OpenAIClient.new(openai_api_key, model)


  File.open("#{output_directory}/#{File.basename(file_path, '.rb')}.md", 'w') do |file|
    code_info.each do |item|
      file.puts "## #{item[:type].to_s.capitalize} #{item[:name]}\n\n"

      summary = generate_method_summary(code, openai_client)
      file.puts "#{summary}\n\n"

      item[:methods].each do |method_name|
        method_code = code[/def #{method_name}.*?end/m]
        summary = generate_method_summary(method_code, openai_client)
        file.puts "### Method #{method_name}\n\n"
        file.puts "#{summary}\n\n"
      end
    end
  end
end

if __FILE__ == $0
  file_path = ARGV[0]
  output_directory = ARGV[1] || 'docs'
  FileUtils.mkdir_p(output_directory)
  generate_documentation(file_path, output_directory)
end


