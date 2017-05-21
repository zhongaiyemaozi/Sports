//
//  AppDelegate.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/10.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //高德地图注册
        AMapServices.shared().apiKey = "c6088ff4350f88171134a9bbfa060c84"

        window = UIWindow(frame: Screen_Bounds)
        window?.rootViewController = CLTabBarController()
        window?.makeKeyAndVisible()
        
        //添加shareSDK
        sharSDK()
        
        return true
    }
    
    fileprivate func sharSDK() {
        
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
        
        ShareSDK.registerApp("1e023f883774f", activePlatforms:[
            SSDKPlatformType.typeSinaWeibo.rawValue,
            SSDKPlatformType.typeWechat.rawValue,
            SSDKPlatformType.typeQQ.rawValue],
                             onImport: { (platform : SSDKPlatformType) in
                                switch platform
                                {
                                case SSDKPlatformType.typeSinaWeibo:
                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                                case SSDKPlatformType.typeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                case SSDKPlatformType.typeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }
                                
        }) { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
            
            switch platform
            {
            case SSDKPlatformType.typeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243",
                                            appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
                                            redirectUri : "http://www.sharesdk.cn",
                                            authType : SSDKAuthTypeBoth)
                
            case SSDKPlatformType.typeWechat:
                //设置微信应用信息
                appInfo?.ssdkSetupWeChat(byAppId: "wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
            case SSDKPlatformType.typeQQ:
                //设置QQ应用信息
                appInfo?.ssdkSetupQQ(byAppId: "100371282",
                                     appKey : "aed9b0303e3ed1e27bae87c33761161d",
                                     authType : SSDKAuthTypeWeb)
            default:
                break
            }
            
        }
        
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


}

