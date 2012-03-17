#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
  end

  task :default => :spec
rescue LoadError
  puts 'RSpec is not installed'
end
