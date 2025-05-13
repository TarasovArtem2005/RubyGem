require_relative 'lib/OllamaAdapter.rb'



client = OllamaAdapter::Censor.new

puts client.censor_file_text("C:/Users/taras/Downloads/article.txt")

