Pod::Spec.new do |s|

  s.name     = "AlamofireSync"
  s.version  = "5.0.0"
  s.summary  = "A Swift extension that allows synchronous requests for Alamofire"
  s.homepage = "https://github.com/gumob/AlamofireSync"
  s.license  = 'MIT'
  s.author   = { "gumob" => "gumob.dev@gmail.com" }
  s.source   = { :git => "https://github.com/gumob/AlamofireSync.git", :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.swift_versions = ['5.1', '5.2']

  s.source_files = 'Source/*.swift'
  s.requires_arc = true

  s.dependency "Alamofire", "~> 5.0"

end
