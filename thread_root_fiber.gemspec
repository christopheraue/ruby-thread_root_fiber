# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thread_root_fiber/version'

Gem::Specification.new do |spec|
  spec.name          = "thread_root_fiber"
  spec.version       = ThreadRootFiber::VERSION
  spec.authors       = ["Christopher Aue"]
  spec.email         = ["mail@christopheraue.net"]

  spec.summary       = %q{Adds Thread#root_fiber, Fiber.root and Fiber#root?}
  spec.description   = <<-DESC
Ruby's threads have no access to their root fibers. This little gem adds:
Thread#root_fiber, Fiber.root and Fiber#root? (also aliased as #root_fiber?).
  DESC
  spec.homepage      = "https://github.com/christopheraue/ruby-thread_root_fiber"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
end
