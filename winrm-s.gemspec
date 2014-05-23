# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "winrm-s/version"

Gem::Specification.new do |s|
  s.name        = "winrm-s"
  s.version     = WinrmS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.authors     = ["Kaustubh Deorukhkar"]
  s.email       = ["kaustubh@clogeny.com"]
  s.homepage    = "https://github.com/opscode/winrm-s"
  s.summary     = %q{Gem that extends the functionality of the WinRM gem to support the Microsoft Negotiate protocol when authenticating to a remote WinRM endpoint from a Windows system}
  s.description = s.summary

  s.add_dependency "winrm", "~> 1.1.2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
