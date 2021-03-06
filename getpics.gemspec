# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'getpics/version'

Gem::Specification.new do |spec|
  spec.name          = "getpics"
  spec.version       = Getpics::VERSION
  spec.authors       = ["Doug P."]
  spec.email         = ["dougtko@gmail.com"]

  spec.summary       = %q{Download pictures from camera}
  spec.description   = %q{Download pictures from camera}
  spec.homepage      = "http://example.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = "getpics" #spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'mini_exiftool'
  spec.add_runtime_dependency 'colorize'
  spec.add_runtime_dependency 'ruby-progressbar'
end
