//
//  AppDelegate.swift
//  SharaBara
//
//  Created by MacBook on 24.05.22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        

        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ success, _ in
            guard success else{
                return
            }
            print("Success APNS Regirstry")
            
            
        }
        
        application.registerForRemoteNotifications()
        
        
        
        // Override point for customization after application launch.
        return true
    }
    
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("Application delegate method userNotificationCenter:didReceive:withCompletionHandler: is called with user info: %@", response.notification.request.content.userInfo)
        
        let content = response.notification.request.content.userInfo
        if let aps = content["link"]{
            let link = aps
            print(link)
            print("calleds")
            delay(1) {
 
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let destinationViewController = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
                        print("ViewController not found")
                        return
                    }
            destinationViewController.myVariable = link as? String
                
            let navigationController = UIApplication.getKeyWindow()?.rootViewController as! UINavigationController

            navigationController.pushViewController(destinationViewController, animated: false)
        }
        }
        /*
        if let aps = response.notification.request.content.userInfo["aps"] as? [String:Any],
           let alertDict = aps["data"] as? [String:String] {
            print("body :", alertDict["link"]!)
            
            
                //logger.log("continuing")
                delay(1) {
     
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let destinationViewController = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
                            print("ViewController not found")
                            return
                        }
                destinationViewController.myVariable = alertDict["link"]
                    
                let navigationController = UIApplication.getKeyWindow()?.rootViewController as! UINavigationController

                navigationController.pushViewController(destinationViewController, animated: false)
            }
           
        }
        */
        //...
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("userNotificationCenter:willPresent")
        //...
        completionHandler([.alert])
    }
    
    

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        let content = userInfo
        if let aps = content["link"]{
            let link = aps
            
            print(link)
            print("called")
            delay(1) {
 
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let destinationViewController = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
                        print("ViewController not found")
                        return
                    }
            destinationViewController.myVariable = link as? String
                
            let navigationController = UIApplication.getKeyWindow()?.rootViewController as! UINavigationController

            navigationController.pushViewController(destinationViewController, animated: false)
        }
        
        
        }
        /*
        if let aps = userInfo["aps"] as? [String:Any],
           let alertDict = aps["data"] as? [String:String] {
            print("body :", alertDict["link"]!)
            
            
                //logger.log("continuing")
                delay(1) {
     
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let destinationViewController = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
                            print("ViewController not found")
                            return
                        }
                destinationViewController.myVariable = alertDict["link"]
                    
                let navigationController = UIApplication.getKeyWindow()?.rootViewController as! UINavigationController

                navigationController.pushViewController(destinationViewController, animated: false)
            }
           
        }
        */

        //let url = userInfo?["url"] as? String {
          //  print(url)
        //}
    }
    

    
    
    
    
    private func messaging(_ messaging: Messaging, didRecaveRegistrationToken fromToken: String?){
        messaging.token {token, _ in
            guard let token = token else {
                return
            }
            print("Token: \(token)")
            
        }
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


}

