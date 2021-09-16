
platform :ios, '10.0'

target 'SwiftSDK' do
  use_frameworks!
  pod 'Socket.IO-Client-Swift', '~> 16.0'

  target 'SwiftSDKTests' do
    inherit! :search_paths
    pod 'Socket.IO-Client-Swift', '~> 16.0'
  end

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
  end
 end
end
