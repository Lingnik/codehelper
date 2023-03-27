require "openai"

class OpenAIClient
  def initialize(api_key, model)
    OpenAI.configure do |config|
      config.access_token = api_key
    end
    @client = OpenAI::Client.new
    @model = model
  end

  def generate_response(prompt, max_tokens = 1000, n = 1, stop = nil, temperature = 0.5, max_retries = 5)
    attempt = 1
    our_max_tokens = 150

    while attempt <= max_attempts
      response = OpenAI::ChatCompletion.create(
        model: @model,
        messages: messages,
        max_tokens: max_tokens,
        n: n,
        stop: stop,
        temperature: temperature,
      )

      content = response["choices"][0]["message"]["content"]
      if ENV['DEBUG'] == 'true'
        puts "---- Full Response Message Content ----"
        puts content 
        puts "----"
      end

      last_line = content.lines.last.chomp
      if last_line == "###END###"
        content = content.chomp("\n###END###")
        return content
      else
        attempt += 1
        puts "Error: The last line must be '###END###', aborted gpt message detected."
        sleep(1)
      end 
    end

    raise "Unable to obtain a complete or properly-formatted message from chatgpt after #{max_attempts} attempts."
  end

  def generate_code(prompt, max_tokens = 150, n = 1, stop = nil, temperature = 0.5, max_attempts = 5)
    attempt = 1
  
    while attempt <= max_attempts
      response = @client.chat(parameters: {
        model: @model,
        messages: [
          {role: "system", content: "You are a helpful assistant that translates English descriptions into concise Ruby code."},
          {role: "user", content: "#{prompt}"}
        ],
        max_tokens: max_tokens,
        n: n,
        stop: stop,
        temperature: temperature
      })
  
      content = response["choices"][0]["message"]["content"]
      backticks_count = content.scan(/```/).count
  
      if backticks_count % 2 == 0
        code_blocks = content.scan(/```ruby\n(.*?)\n```/m).flatten
        extracted_code = code_blocks.map(&:strip).join("\n\n")
  
        if ENV['DEBUG'] == 'true'
          puts "---- Full Response Message Content ----"
          puts content
          puts "---- Extracted Code Blocks ----"
          puts extracted_code
        end
  
        return extracted_code
      else
        attempt += 1
        puts "Unbalanced triple backticks detected. Retrying (attempt #{attempt})..." if ENV['DEBUG'] == 'true'
      end
    end
  
    raise "Unable to generate code with balanced triple backticks after #{max_attempts} attempts."
  end

end
