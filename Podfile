# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Sport-Swift' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sport-Swift
    pod 'AMap3DMap', '~> 4.1.0'
    pod 'SnapKit'
    pod 'SDWebImage'
    # 主模块(必须)
    pod 'ShareSDK3'
    # Mob 公共库(必须) 如果同时集成SMSSDK iOS2.0:可看此注意事项：http://bbs.mob.com/thread-20051-1-1.html
    pod 'MOBFoundation'
    
    # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
    pod 'ShareSDK3/ShareSDKUI'
    
    # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
    pod 'ShareSDK3/ShareSDKPlatforms/QQ'
    pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
    pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
    
    
    # 使用配置文件分享模块（非必需）
    pod 'ShareSDK3/ShareSDKConfigurationFile'
    
    # 扩展模块（在调用可以弹出我们UI分享方法的时候是必需的）
    pod 'ShareSDK3/ShareSDKExtension'
    
    
  target 'Sport-SwiftTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Sport-SwiftUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
