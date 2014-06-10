
require 'winrm'

def windows?
  !!(RUBY_PLATFORM =~ /mswin|mingw|windows/)
end

# Monkey patch only on windows
if windows?
  require 'winrm/winrm_service_patch'
else
  raise "ERROR: winrm-s does not monkey patch the winrm gem in *nix. You should use winrm gem on *nix."
end