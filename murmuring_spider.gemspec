# -*- encoding: utf-8 -*-
require File.expand_path('../lib/murmuring_spider/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["tomykaira"]
  gem.email         = ["tomykaira@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.add_dependency('dm-core')
  gem.add_dependency('dm-migrations')
  gem.add_dependency('dm-validations')
  gem.add_dependency('twitter')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('guard')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('database_cleaner')
  gem.add_development_dependency('dm-sqlite-adapter')
  gem.add_development_dependency('rake')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "murmuring_spider"
  gem.require_paths = ["lib"]
  gem.version       = MurmuringSpider::VERSION
end
