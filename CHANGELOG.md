# winrm-s  Change Log
Release: 0.3.3
--------------
* Do not emit warnings for either httpclient versions 2.6 or 2.7

Release: 0.3.2
--------------
* Strip UTF-8 BOM from response added by win2k8R2 since newer WinRM versions now use UTF-8
* Decode all authorized payloads, not just successful ones so an unsuccesful command error can be communicated

Release: 0.3.1
--------------
* [Issue #27](https://github.com/chef/winrm-s/pull/27): Fixes problem with AllowUnencrypted being true and using negotiate

Release: 0.3.0
--------------
* [Issue #21](https://github.com/chef/winrm-s/issues/21): Bumps winrm dependency from 1.2 to 1.3.
* [Issue #25](https://github.com/opscode/winrm-s/pull/25): [Fix for knife-windows issue 218](https://github.com/opscode/knife-windows/issues/218)

Release: 0.2.4
--------------
* DOC change only: correct omission from CHANGELOG items in 0.2.3 release

Release: 0.2.3
--------------
* [Issue #20](https://github.com/chef/winrm-s/pull/20): Allow support for httpclient 2.6

Release: 0.2.2
--------------
* [Issue #16](https://github.com/opscode/winrm-s/pull/16): [fix for knife-windows issue 124](https://github.com/opscode/knife-windows/issues/124)
* [Issue #15](https://github.com/opscode/winrm-s/pull/15): drop Ruby 1.9.2 builds from Travis

Release: 0.2.0
--------------
* Fix invalid use of frozen string ENV block is used for user and domain
* Update to WinRM 1.2.0 gem dependency

Release: 0.1.0
--------------
* Initial implementation
