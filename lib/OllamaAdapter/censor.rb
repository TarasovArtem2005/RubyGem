require 'net/http'
require 'json'
require 'uri'

module OllamaAdapter
  class Censor
    def initialize(model: "llama3", host: "http://localhost:11434")
      @model = model
      @host = host
    end

    def censor(text)
      prompt = <<~PROMPT
        Прочитай текст на русском языке, удали все плохие слова и маты или замени все плохие слова и маты на приличные синонимы и сразу верни JSON вида:
        {
          "text": "..."
          "censored_amount": "..."
        }
        
        Текст:
        #{text}
      PROMPT

      generate(prompt)
    end

    def censor_file_text(file_path)
      File.open(file_path) do |file|
        res = censor(file.read)
        File.write(file_path, res)
      end
    end


    private
    def generate(prompt)
      uri = URI("#{@host}/api/generate")
      body = {
        model: @model,
        prompt: prompt,
        stream: false
      }
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 500
      response = http.post(uri, body.to_json, { 'Content-Type' => 'application/json' })
      JSON.parse(response.body)["response"][/\{.*?\}/m]
    end
  end
end
