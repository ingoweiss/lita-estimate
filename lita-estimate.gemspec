Gem::Specification.new do |spec|
  spec.name          = "lita-estimate"
  spec.version       = "0.1.7"
  spec.authors       = ["Ingo Weiss"]
  spec.email         = ["ingo@ingoweiss.com"]
  spec.description   = "Just a silly little Lita plugin for estimation"
  spec.summary       = "Just a silly little Lita plugin for estimation"
  spec.homepage      = "https://github.com/ingoweiss/lita-estimate"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "byebug"
end
