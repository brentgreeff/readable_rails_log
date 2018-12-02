
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "readable_rails_log/version"

Gem::Specification.new do |spec|
  spec.name = "readable_rails_log"
  spec.version = ReadableRailsLog::VERSION
  spec.authors = ["Brent Greeff"]
  spec.email = ["brentgreeff@gmail.com"]

  spec.summary = %q{Expands SQL queries into multiple lines so they are easier to read.}
  spec.homepage = "http://x.com"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rainbow"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "chronic"
  spec.add_development_dependency "activesupport", "~> 5.1"
end
