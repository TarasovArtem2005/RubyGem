require 'net/http'
require 'json'
require 'uri'

module OllamaAdapter

  class Client
    def initialize(model: "llama3", host: "http://localhost:11434")
      @model = model
      @host = host
    end

    def summarize_article(text)
      prompt = <<~PROMPT
        Прочитай текст и сразу верни JSON вида:
        {
          "title": "...",
          "summary": "...",
          "keywords": ["...", "..."]
        }

        Текст:
        #{text}
      PROMPT

      raw = generate(prompt)
      puts raw.class
      puts raw.size
      raw
      # JSON.parse(raw) rescue { error: "Ошибка разбора JSON: #{raw}" }
    end

    def summarize_file_text(file_path)
      File.open(file_path) do |file|
        return summarize_article(file.read)
      end
    end

    def summarize_folder(folder_path)
      Dir.mkdir(folder_path + "_summary/")
      Dir.glob(folder_path + "/*") do |file_path|
        next unless File.file?(file_path)
        File.open(file_path) do |file|
          summary = summarize_article(file.read)
          new_file_path = File.join(folder_path + "_summary/", File.basename(file_path))
          File.write(new_file_path, summary)
          puts "#{file_path} summarized to #{new_file_path}"
        end
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
      http.read_timeout = 300
      response = http.post(uri, body.to_json, { 'Content-Type' => 'application/json' })
      # response = Net::HTTP.post(uri, body.to_json, { 'Content-Type' => 'application/json' })
      JSON.parse(response.body)["response"][/\{.*?\}/m]

    end
  end
end
