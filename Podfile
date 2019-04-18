# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'rss-ios' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Analytics
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
    pod 'FirebaseAnalytics'
    pod 'Firebase/Messaging'
    pod 'Firebase/Performance'
    pod 'Firebase/AdMob'
    
    # UI
    pod 'Toast-Swift'
    pod 'SDWebImage', '~> 4.0'
    pod 'JGTabBarView', :path => '~/Documents/GitSource/JGTabBarView/'
    pod 'JGWebView', :git => 'https://github.com/junggate/JGWebView.git'
    pod 'RNNotificationView'
    
    # Fountional
    pod 'RxCocoa'
    pod 'RxSwift'
    
    # Database
    pod 'RealmSwift'
    
    # CodeStyle
    pod 'SwiftLint'
    
    # Communication
    pod 'Alamofire'
    pod 'RxAlamofire'
    
    # Extension
    pod 'JGExtension', :path => '../JGExtension/'
    #  pod 'JGExtension'
    
    # Mapping
    pod 'HandyJSON', '~> 4.2.0'
    
    # Social
    pod 'KakaoOpenSDK'
    pod 'KakaoOpenSDK'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
    pod 'naveridlogin-sdk-ios'

    # Cocoapods License
    #pod 'ESOpenSourceLicensesKit'
    
    # Ad
    pod 'Google-Mobile-Ads-SDK'
    
    target 'rss-iosTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    target 'rss-iosUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            end
            
            #print "Setting the default SWIFT_VERSION to 4.2\n"
            installer.pods_project.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
            
            installer.pods_project.targets.each do |target|
                if [''].include? "#{target}"
                    # print "Setting #{target}'s SWIFT_VERSION to 4.0\n"
                    target.build_configurations.each do |config|
                        config.build_settings['SWIFT_VERSION'] = '4.0'
                    end
                    else
                    # print "Setting #{target}'s SWIFT_VERSION to Undefined (Xcode will automatically resolve)\n"
                    target.build_configurations.each do |config|
                        config.build_settings.delete('SWIFT_VERSION')
                    end
                end
            end
        end
    end
end
