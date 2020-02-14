Pod::Spec.new do |s|
  s.name         = "BackendlessSwift"
  s.module_name  = "Backendless"
  s.version      = "5.7.4"
  s.source = { :git => 'https://github.com/Backendless/Swift-SDK.git', :tag => '5.7.4' }
  s.license      = { :type => 'MIT', :text => 'Copyright (c) 2013-2020 by Backendless Corp' }
  s.homepage     = "http://backendless.com"
  s.authors      = { 'Mark Piller' => 'mark@backendless.com', 'Olha Danylova' => 'olga@themidnightcoders.com' }
  s.summary      = "Backendless is a Mobile Backend and API Services Platform"
  s.description  = "Backendless is a development and a run-time platform. It helps software developers to create mobile and desktop applications while removing the need for server-side coding."
  s.swift_version = "5"
  s.pod_target_xcconfig = {
      'SWIFT_VERSION' => '5.0'
  }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true
  s.source_files = "Sources/SwiftSDK/**/*.swift", "Sources/SwiftSDK/*.swift", "Tests/SwiftSDKTests/TestObjects/*.swift"
  s.dependency "Socket.IO-Client-Swift"
  
end
