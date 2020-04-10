
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cmus-bt/version"

Gem::Specification.new do |spec|
  spec.name          = "cmus-bt"
  spec.version       = CMusBt::VERSION
  spec.authors       = ["Hirosho Kuwagata"]
  spec.email         = ["kgt9221@gmail.com"]

  spec.summary       = %q{Bluetooth AVRCP wrapper for cmus.}
  spec.description   = %q{Bluetooth AVRCP wrapper for cmus.}
  spec.homepage      = "https://github.com/kwgt/cmus-bt"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been
  # added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f|
      f.match(%r{^(test|spec|features)/})
    }
  end

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["none"]
  spec.extensions    = %w[]

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_development_dependency "bundler", ">= 2.1"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_dependency "ruby-dbus", "~> 0.16.0"
  spec.add_dependency "systemu", "~> 2.6.5"
end
