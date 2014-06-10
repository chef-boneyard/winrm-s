winrm-s
=======

`winrm-s` extends the functionality of the
[WinRM gem](http://rubygems.org/gems/winrm) to support the Microsoft
[Negotiate protocol](http://msdn.microsoft.com/en-us/library/windows/desktop/aa378748(v=vs.85).aspx)
when authenticating to a remote [WinRM](http://msdn.microsoft.com/en-us/library/aa384426(v=vs.85).aspx) endpoint from a Windows system.

Installation
------------

To install it, run:

    gem install winrm-s

Usage
-----

`winrm-s` provides the same interface as the `winrm` gem -- see `winrm`
[documentation](https://github.com/WinRb/WinRM/blob/master/README.md) for `winrm-s` usage.

Example
-------
Note the argument value of **:sspinegotiate** for transport option.
```ruby
require 'winrm-s'
endpoint = http://mywinrmhost:5985/wsman
winrm = WinRM::WinRMWebService.new(endpoint, :sspinegotiate, :user => ".\administrator", :pass => "adminpasswd")
winrm.cmd('ipconfig /all') do |stdout, stderr|
  STDOUT.print stdout
  STDERR.print stderr
end
```

License
-------

Copyright:: Copyright (c) 2014 Chef Software, Inc.
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

