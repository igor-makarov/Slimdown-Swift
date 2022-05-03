Pod::Spec.new do |s|
  s.name        = "Slimdown"
  s.version     = "0.1.0"
  s.summary     = "Slimdown parser, implemented in Swift"
  s.homepage    = "https://github.com/igor-makarov/Slimdown-Swift"
  s.license     = { :type => "MIT" }
  s.authors     = { "Igor Makarov" => "igormaka@gmail.com" }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target     = '10.9'
  s.swift_version = "4.2"
  s.source   = { :git => "https://github.com/igor-makarov/Slimdown-Swift.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*.swift"
  s.frameworks  = "Foundation"
end
