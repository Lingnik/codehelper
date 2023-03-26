require "openai"

class OpenAIClient
  def initialize(api_key, model)
    OpenAI.configure do |config|
      config.access_token = api_key
    end
    @client = OpenAI::Client.new
    @model = model
  end

  def generate_code(prompt, max_tokens = 150, n = 1, stop = nil, temperature = 0.5)
    response = @client.chat(parameters: {
      model: @model,
      messages: [
        {role: "system", content: "You are a helpful assistant that translates English descriptions into Ruby code."},
        {role: "user", content: "#{prompt}"}
      ],
      max_tokens: max_tokens,
      n: n,
      stop: stop,
      temperature: temperature
    })
  
    content = response["choices"][0]["message"]["content"]
    code_blocks = content.scan(/```ruby(.*?)```/m).flatten
    extracted_code = code_blocks.map(&:strip).join("\n\n")
  
    if ENV['DEBUG'] == 'true'
      puts "---- Full Response Message Content ----"
      puts content
      puts "---- Extracted Code Blocks ----"
      puts extracted_code
    end
  
    extracted_code
  end
end
