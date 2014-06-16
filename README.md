winrm-s
=======

`winrm-s` extends the functionality of the
[WinRM gem](http://rubygems.org/gems/winrm) to support the Microsoft
[Negotiate protocol](http://msdn.microsoft.com/en-us/library/windows/desktop/aa378748(v=vs.85).aspx)
when authenticating to a remote [WinRM](http://msdn.microsoft.com/en-us/library/aa384426(v=vs.85).aspx) endpoint from a Windows system.

This extended functionality is **only** supported when running on Microsoft
Windows. This gem can still be used on other operating systems just like the
`WinRM` gem, but the extended capabilities will not be available.

Installation
------------

To install it, run:

    gem install winrm-s

Usage
-----

`winrm-s` provides the same interface as the `winrm` gem -- see `winrm`
[documentation](https://github.com/WinRb/WinRM/blob/master/README.md) for `winrm-s` usage.

* To use it, simply require `winrm` or `winrm-s`, depending on whether your code
is running on Windows. The extended negotiate protocol is only available if
you include `winrm-s`, which will only work on Windows.
* When you use WinRM::WinRMWebService.new, be sure to specify the
  `:sspinegotiate` parameter, along with a user name in the form `domain_name\user_name`
  for the user name in order to make use of negotiate protocol. If the user
  account is local to the remote system, you can use `.` for the domain. The
  example further on demonstrates the negotiate use case.
* All other use cases enabled by the `winrm` gem are also supported.

Example
-------
Note the argument value of `:sspinegotiate` for transport option, and the
explicit specification of a domain name, in this case `.`, in the user name:
```ruby
if RUBY_PLATFORM =~ /mswin|mingw32|windows/
  require 'winrm-s' # only works on Windows, otherwise use require 'winrm'
  endpoint = http://mywinrmhost:5985/wsman
  winrm = WinRM::WinRMWebService.new(endpoint, :sspinegotiate, :user => ".\administrator", :pass => "adminpasswd")
  winrm.cmd('ipconfig /all') do |stdout, stderr|
    STDOUT.print stdout
    STDERR.print stderr
  end
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

