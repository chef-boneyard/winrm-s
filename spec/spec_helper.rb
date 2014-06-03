$:.unshift File.expand_path('../../lib', __FILE__)

require 'winrm-s'

def windows?
  !!(RUBY_PLATFORM =~ /mswin|mingw|windows/)
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding :windows_only => true unless windows?
end