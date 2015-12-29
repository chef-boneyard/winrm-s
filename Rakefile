require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

task :default => [:unit_spec]

desc "Run all functional specs in spec directory"
RSpec::Core::RakeTask.new(:functional_spec) do |t|
t.pattern = 'spec/functional/**/*_spec.rb'
end

desc "Run all unit specs in spec directory"
RSpec::Core::RakeTask.new(:unit_spec) do |t|
t.pattern = 'spec/unit/**/*_spec.rb'
end
