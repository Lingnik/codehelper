require "openai"

##
# The `OpenAIClient` class provides an interface for interacting with the OpenAI API.
# 
# Use the `initialize` method to create an instance of the `OpenAIClient` class:
# 
# ```ruby
# client = OpenAIClient.new(api_key, model)
# ```
# 
# You'll need an API key from OpenAI to use this class. You can sign up for an API key on the OpenAI website.
# 
# The `OpenAIClient` class provides the following methods for generating responses from the API:
# 
# - {#generate_json_response} - Generates a JSON response from the API.
# - {#generate_code} - Generates Ruby code from a given prompt using the API.
# - {#generate_raw_response} - Generates a raw response from the API.
#
# Example usage:
#
# ```ruby
# client = OpenAIClient.new(api_key, model)
# response = client.generate_code("Sort an array of numbers.")
# ```
class OpenAIClient
  ##
  # Initializes a new OpenAIClient object.
  #
  # @param [String] api_key Your OpenAI API key.
  # @param [String] model The name of the model to use for generating responses.
  def initialize(api_key, model)
    OpenAI.configure do |config|
      config.access_token = api_key
    end
    @client = OpenAI::Client.new
    @model = model
  end

  ##
  # Generates a JSON response from the OpenAI API.
  #
  # @param [Array] messages The messages to send to the API.
  # @param [Integer] max_tokens The maximum number of tokens to generate.
  # @param [Integer] n The number of responses to generate.
  # @param [String, nil] stop A string at which generation is stopped.
  # @param [Float] temperature The sampling temperature to use.
  # @param [Integer] max_attempts The maximum number of attempts to generate a response.
  # @return [String] The generated JSON response.
  def generate_json_response(messages, max_tokens = 1000, n = 1, stop = nil, temperature = 0.5, max_attempts = 5)
    attempt = 1

    while attempt <= max_attempts
      response = @client.chat(parameters: {
          model: @model,
          messages: messages,
          max_tokens: max_tokens,
          n: n,
          stop: stop,
          temperature: temperature,
        }
      )

      if response["choices"].nil?
        puts response
        raise "Error: The 'choices' key is missing or has a nil value in the response."
      end

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

  ##
  # Generates Ruby code from a given prompt using the OpenAI API.
  #
  # @param [String] prompt The prompt to generate code from.
  # @param [Integer] max_tokens The maximum number of tokens to generate.
  # @param [Integer] n The number of responses to generate.
  # @param [String, nil] stop A string at which generation is stopped.
  # @param [Float] temperature The sampling temperature to use.
  # @param [Integer] max_attempts The maximum number of attempts to generate a response.
  # @return [String] The generated Ruby code.
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

  ##
  # Generates a raw response from the OpenAI API.
  #
  # @param [Array] messages The messages to send to the API.
  # @param [Integer] max_tokens The maximum number of tokens to generate.
  # @param [Integer] n The number of responses to generate.
  # @param [String, nil] stop A string at which generation is stopped.
  # @param [Float] temperature The sampling temperature to use.
  # @return [String] The raw generated response.
  def generate_raw_response(messages, max_tokens = 1000, n = 1, stop = nil, temperature = 0.5)
    response = @client.chat(parameters: {
        model: @model,
        messages: messages,
        max_tokens: max_tokens,
        n: n,
        stop: stop,
        temperature: temperature,
      }
    )

    if response["choices"].nil?
      puts response
      raise "Error: The 'choices' key is missing or has a nil value in the response."
    end

    content = response["choices"][0]["message"]["content"]
    if ENV['DEBUG'] == 'true'
      puts "---- Full Response Message Content ----"
      puts content 
      puts "----"
    end

    content
  end

end
