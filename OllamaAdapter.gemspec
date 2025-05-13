# frozen_string_literal: true

require_relative "lib/OllamaAdapter/version"

Gem::Specification.new do |spec|
  spec.name = "OllamaAdapter"
  spec.version = OllamaAdapter::VERSION
  spec.authors = ["Artem"]
  spec.email = ["tarasovartems@gmail.com"]

  spec.summary = "Simple adapter to do some useful editing job using Ollama"
  spec.description = "There are two useful classes for editing texts or articles: Client who can summarize article or summarize whole folder of articles creating json files to each one,
  and Censor who can censor text using Ollama model. Before using them you should start Ollama server locally or u can replace host param in initialize method with server url where Ollama model is running."
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
