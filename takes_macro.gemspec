
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "takes_macro/version"

Gem::Specification.new do |spec|
  spec.name          = "takes_macro"
  spec.version       = TakesMacro::VERSION
  spec.authors       = ["David Pedersen"]
  spec.email         = ["david.pdrsn@gmail.com"]

  spec.summary       = %q{Remove boilerplate for writing initializers}
  spec.description   = %q{A faster implementation of `pattr_initialize` from the attr_extras gem}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
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

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "benchmark-ips", "~> 2.7.2"
  spec.add_development_dependency "attr_extras", "~> 5.2.0"
end
