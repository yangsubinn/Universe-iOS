//
//  AppDelegate.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2022/12/27.
//

import UIKit
import UniverseKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var moduleFactory = ModuleFactory.shared
    
    var orientationLock = UIInterfaceOrientationMask.portrait
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UniverseKit.registerFonts()
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { granted, _ in
                print("permission granted: \(granted)")
            }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.sound, .banner, .list])
        if userInfo["matchId"] == nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { [weak self] in
                self?.postObserverAction(.popToStadiumListVC)
            }
        }
    }
    
    /// 완전 종료되지 않은 상태에서 푸시 받는 경우 처리 (background / inactive / active)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let applicationState = UIApplication.shared.applicationState
        
        switch applicationState {
        case .active, .inactive:
            if let matchId = (userInfo["matchId"] as? NSString)?.floatValue {
                let baseTBC = moduleFactory.makeBaseVC()
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let window = windowScene.windows.first  else { return }
                window.rootViewController = baseTBC
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    if let topVC = baseTBC.selectedViewController as? UINavigationController {
                        let playVC = self.moduleFactory.makePlayVC(.live, type: .enableControl, matchId: Int(matchId))
                        topVC.topViewController?.hidesBottomBarWhenPushed = true
                        topVC.pushViewController(playVC, animated: true)
                    }
                }
            } else {
                self.postObserverAction(.popToStadiumListVC)
            }
        default:
            break
        }
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcm:", fcmToken as Any)
        UserDefaults.standard.set(fcmToken, forKey: Const.UserDefaultsKey.fcmToken)
    }
}
