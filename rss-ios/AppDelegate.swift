//
//  AppDelegate.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 03/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import KakaoCommon
import KakaoOpenSDK
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import NaverThirdPartyLogin
import UserNotifications
import FirebaseMessaging
import Crashlytics
import GoogleMobileAds
import RxSwift
import RxCocoa

//ca-app-pub-2432290974439865~5314360493
//ca-app-pub-2432290974439865/9313315257

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let userUseCase = UserUseCase()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        #if DEBUG
        let testAdId = "ca-app-pub-3940256099942544/2934735716"
        GADMobileAds.configure(withApplicationID: testAdId)
        #else
        let realAdId = "ca-app-pub-2432290974439865~5314360493"
        GADMobileAds.configure(withApplicationID: realAdId)
        #endif
        
        setupPushNotification(application: application)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [: ]) -> Bool {
        if KOSession.handleOpen(url) {
            return true
        } else if let scheme = url.scheme, scheme == "naverlogin-rssproject" {
            NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
            let token = NaverThirdPartyLoginConnection.getSharedInstance().accessToken
            print("naver accessToken \(token ?? "")")
            return true
        }
        
        if url.absoluteString.contains("fb") {
            return FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options) ?? false
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        InstanceID.instanceID().instanceID { [weak self] (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//            }
//        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        setDevieToken(deviceToken: fcmToken)
        let dataDict = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        print(userInfo)
        
        if let aps = userInfo["aps"] as? [String: Any], let alert = aps["alert"] as? [String: String] {
            NotificationView.show(title: alert["title"],
                                  message: alert["body"],
                                  url: nil)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // MARK: - Private
    
    private func setupPushNotification(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] (allow, error) in
                
        })
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    private func setDevieToken(deviceToken: String?) {
        if let navigationController = window?.rootViewController as? NavigationController,
            let splashViewController = navigationController.viewControllers.first as? SplashViewController {
            splashViewController.deviceToken = deviceToken
        }
    }
}
