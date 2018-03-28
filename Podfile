# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'ios-realestate' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

    pod 'RxCocoa'
    pod 'RxSwift'
    pod 'EVReflection'

  target 'ios-realestateTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ios-realestateUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
          end
      end
  end

end
