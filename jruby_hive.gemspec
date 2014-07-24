# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "jruby_hive"
  spec.version       = "0.0.4"
  spec.authors       = ["Shinji Ikeda"]
  spec.email         = ["gm.ikeda@gmail.com"]
  spec.summary       = %q{jruby hive api}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/shinjiikeda/jruby_hive"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "hdfs_jruby"
end
