#
# Author:: Kaustubh Deorukhkar (<kaustubh@clogeny.com>)>
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'winrm'

def windows?
  !!(RUBY_PLATFORM =~ /mswin|mingw|windows/)
end

# Patch only on windows
if windows?
  require 'winrm/winrm_service_patch'
else
  raise "ERROR: winrm-s extensions to the winrm gem for the negotiate protocol are only supported on Windows. Require 'winrm' and not 'winrm-s' on non-Windows platforms."
end
