# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
target 'EtsyExample' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for EtsyExample
  
  # Сontrols
  pod 'KVNProgress', '= 2.3.5'
  pod 'SDWebImage', '= 5.0.2'
  pod 'CCBottomRefreshControl', '= 0.5.2'
  
  # Tools
  pod 'SwiftGen', '~> 6.1'
  pod 'Reusable', '= 4.0.5'
  pod 'Swiftification', '= 11.0.1'
  pod 'Bolts-Swift', '~> 1.4'
  
  # Network
  pod 'Alamofire', '= 5.0.0-beta.6'
  pod 'AlamofireObjectMapper', '~> 6.0'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
      config.build_settings['ENABLE_BITCODE'] = 'YES'

      if config.name == 'Debug'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
        else
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end
