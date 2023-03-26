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
    response = @client.completions(parameters: {
      model: @model,
      prompt: prompt,
      max_tokens: max_tokens,
      n: n,
      stop: stop,
      temperature: temperature,
    })

    response["choices"][0]["text"]
  end
end
