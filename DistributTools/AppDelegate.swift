//
//  AppDelegate.swift
//  DistributTools
//
//  Created by zhangyinglong on 2016/12/30.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

import UIKit
import Darwin
import MLTransition

public struct PgyerModule {
    public static let downloadUrl: String = "http://www.pgyer.com/FLhK"
    public static let host: String = "http://www.pgyer.com"
    public static let image_host: String = "http://7kttjt.com1.z0.glb.clouddn.com/image/view/app_icons/"
    
    /// 设置蒲公英参数
    public static let api_key: String = ""
    public static let uKey: String = ""
    public static let aId: String = ""
    public static let aKey: String = ""
}

public struct AppIdentifierModule {
    /// 设置企业版应用的appIdentifier
    public static let enterprise_appIdentifier: String = ""
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func getNavigationController() -> UINavigationController {
        return self.window?.rootViewController as! UINavigationController
    }

    func networkDidReceiveMessage(notification: NSNotification) {
        // 获取自定义消息
        let userInfo = notification.userInfo! as NSDictionary
        
        // 获取消息内容
        let aps = userInfo["aps"]
        if aps != nil {
            let dic = aps as! NSDictionary
            let num = dic["badge"]
            let badge = num as? NSNumber //badge数量
            UIApplication.shared.applicationIconBadgeNumber = (badge?.intValue)!
        }
        
//        var url = userInfo["url"]
//        //推送显示的内容
//        let content = (userInfo["content"] != nil) ? userInfo["content"] : aps!["alert"]
//        
//        // 弹框
//        let alertView: UIAlertView = UIAlertView(title: "新消息",
//                                                 message: (content as! String),
//                                                 delegate: nil,
//                                                 cancelButtonTitle: "忽略",
//                                                 otherButtonTitles: "现在查看")
//        alertView.rac_buttonClickedSignal().subscribeNext( { [weak self] (obj) -> Void in
//            let index: Int = obj as! Int
//            if index == 1 {
//                // 获取自定义字段
//                let extras = userInfo["extras"]
//                if extras != nil {
//                    let dic: Dictionary<String, String> = extras as! Dictionary<String, String>
//                    if dic["url"] != nil {
//                        url = dic["url"]
//                    }
//                }
//                
//                if url != nil {
//                    let vc: Html5ViewController = Html5ViewController()
//                    vc.isModalViewController = true
//                    vc.url = (url as! String)
//                    vc.content = (content as! String)
//                    let navigationController: UINavigationController = UINavigationController(rootViewController: vc)
//                    navigationController.navigationBar.hidden = true
//                    self!.window?.rootViewController?.presentViewController(navigationController, animated: true, completion: nil)
//                }
//            }
//        })
//        alertView.show()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        MLTransition.validatePanBack(with: MLTransitionGestureRecognizerTypePan)
        DatabaseServiece.shared()
        
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
        
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

