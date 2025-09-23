# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "heimdall/version"

Gem::Specification.new do |spec|
  spec.name          = "heimdall"
  spec.version       = Heimdall::VERSION
  spec.authors       = ["Nwocha Adim", "Chris Woodford"]
  spec.email         = ["adimoranma.felix@andela.com", "chris@gobble.com"]

  spec.summary       = %q{The all seeing guardian of gobble's delivery areas}
  spec.description   = %q{Houses all gobble's delivery areas, reports invalid areas and validates addresses}
  spec.homepage      = "https://github.com/gobble/heimdall"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "activemodel"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "lob", "~> 5.1"
  spec.add_runtime_dependency "intelligent_foods"
end
