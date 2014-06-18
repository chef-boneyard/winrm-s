$:.unshift File.expand_path('../../lib', __FILE__)

require 'nokogiri'

def windows?
  !!(RUBY_PLATFORM =~ /mswin|mingw|windows/)
end

def unix?
  !windows?
end

def windows_and_func_spec_enabled?
  windows? and ENV["enable_winrms_func_spec"]
end

RSpec.configure do |config|
  config.filter_run_excluding :windows_only => true unless windows?
  config.filter_run_excluding :windows_and_func_spec_enabled => true unless windows_and_func_spec_enabled?
  config.filter_run_excluding :unix_only => true unless unix?
end