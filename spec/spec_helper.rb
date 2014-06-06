$:.unshift File.expand_path('../../lib', __FILE__)

require 'winrm-s'

def windows?
  !!(RUBY_PLATFORM =~ /mswin|mingw|windows/)
end

def unix?
  !windows?
end

RSpec.configure do |config|
  config.filter_run_excluding :windows_only => true unless windows?
  config.filter_run_excluding :unix_only => true unless unix?
end