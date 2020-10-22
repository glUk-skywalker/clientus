require_relative 'lib/tusclient/version'

Gem::Specification.new do |spec|
  spec.name          = "tusclient"
  spec.version       = Tusclient::VERSION
  spec.authors       = ["Oleg Ivanov"]
  spec.email         = ["gluk.main+github@gmail.com"]

  spec.summary       = %q{A simple client for the Tus protocol}
  spec.description   = %q{A client for the Tus protocol enabling file uploads}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "<none yet>"
  spec.metadata["changelog_uri"] = "<none yet>"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rubocop', '~> 1.0'
end
