# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Example1' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Example1
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'ChameleonFramework/Swift'
  pod 'Moya-ModelMapper/RxSwift'
  pod 'RxOptional'
  pod 'RxAlamofire/RxCocoa'
  pod 'ObjectMapper'
  
  target 'Example1Tests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
