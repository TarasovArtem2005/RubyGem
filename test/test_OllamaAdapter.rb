# frozen_string_literal: true

require "test_helper"

class TestOllamaAdapter < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::OllamaAdapter::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_summarize_text
    client = OllamaAdapter::Client.new
    res = client.summarize_article("Hello my name is Alex, I love my mom")
    assert res.size > 0
    assert_silent { JSON.parse(res) }
  end

  def test_censor_text
    client = OllamaAdapter::Censor.new
    client.censor_file_text("C:/Users/taras/Downloads/article.txt")
    File.open("C:/Users/taras/Downloads/article.txt") do |file|
      assert file.read.size > 0
    end
  end
end
