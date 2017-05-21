//
//  CLSportTrackingModel.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/10.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

/**
 运动类型的枚举
 
 - CLSportTypeRun: 跑
 - CLSportTypeWalk: 走
 - CLSportTypeBike: 骑行
 */
enum CLSportType: NSInteger {
    case CLSportRun = 1
    case CLSportWalk = 2
    case CLSportBike = 3
}

/**
 状态枚举
 
 - CLSportStateContuter: 继续
 - CLSportStatePause: 暂停
 - CLSportStateFinish: 停止
 */
enum CLSprotState: NSInteger {
    case CLSprotStateContuter = 1
    case CLSprotStatePause = 2
    case CLSprotStateFinish = 3
}

/// GPS信号强度枚举
///
/// - CLSportGPSSignalStateClose: 无信号
/// - CLSportGPSSignalBad: 信号弱
/// - CLSportGPSSignalNormal: 信号一般
/// - CLSportGPSSignalGood: 信号好
enum CLSportGPSSignalState:NSInteger {
    case CLSportGPSSignalStateClose = 1
    case CLSportGPSSignalBad = 2
    case CLSportGPSSignalNormal = 3
    case CLSportGPSSignalGood = 4
}

class CLSportTrackingModel: NSObject {
    
    /// 起始CLLocation
    fileprivate var startLocation: CLLocation?
    //运动状态枚举
    var sportState: CLSprotState? {
        didSet {
            if self.sportState == CLSprotState.CLSprotStatePause {
                //当状态是暂停的时候把初始位置设为nil
                self.startLocation = nil
            }
            
        }
    }
    
    /// 轨迹模型数组
    fileprivate var trackLineArrM: NSMutableArray = []
    
    /// 枚举
    fileprivate let sportType: CLSportType?
    
    /// GPS信号枚举
    fileprivate var sportGPSSingalState:CLSportGPSSignalState?
    
    /// 运动总距离
    var totalDistance: Float {
        get{
            return trackLineArrM.value(forKeyPath: "@sum.distance") as! Float
        }
    }
    /// 运动总时间
    var totalTime: Float {
        get{
            return trackLineArrM.value(forKeyPath: "@sum.time") as! Float
        }
    }
    /// 运动总时间字符串
    var totalTimeStr: String {
        get{
            let hour: Int = (Int(self.totalTime) / 3600)
            let mintute: Int = Int(self.totalTime) / 60
            let second: Int = Int(self.totalTime .truncatingRemainder(dividingBy: 60))
            return String(format: "%02zd", hour) + ":" + String(format: "%02zd",mintute) + ":" + String(format: "%02zd",second)
        }
    }
    
    /// 平均速度
    var avgSpeed: Float {
        get{
            guard trackLineArrM.count != 0 else {
                
                return 0.00
            }
            return trackLineArrM.value(forKeyPath: "@avg.speed") as! Float
        }
    }

    /// 最大速度
    var maxSpeed: Float {
        get{
            guard trackLineArrM.count != 0 else {
                return 0.00
            }
            return trackLineArrM.value(forKeyPath: "@max.speed") as! Float
        }
    }
    
    init(type: CLSportType,state: CLSprotState) {
        
        self.sportType = type
        self.sportState = state
        super.init()
    }
    
}

extension CLSportTrackingModel {
    
    func sportImage()->UIImage {
        var image: UIImage?
        if sportType == CLSportType.CLSportRun {
            image = UIImage(named: "map_annotation_run.png");
        }else if sportType == CLSportType.CLSportWalk {
            image = UIImage(named: "map_annotation_walk.png");
        }else {
            image = UIImage(named: "map_annotation_bike.png");
        }
        return image!
    }
    
    /// 绘制折先
    ///
    /// - Parameter location: 当前位置
    /// - Returns: 折线模型
    func drawPolyLineWithLocation(location: CLLocation) -> CLSportPolyLine {
        
        //时间优化算法
        if NSDate().timeIntervalSince(location.timestamp) >= 2 {
            return CLSportPolyLine()
        }
        //速度优化算法
        if location.speed <= 0 {
            return CLSportPolyLine()
        }
        
        //如果是暂停，就不继续往下画线
        if self.sportState == CLSprotState.CLSprotStatePause {
            return CLSportPolyLine()
        }
        
        //如果GPS信号强度不为好，则不绘制轨迹
        if gpsSignalStateWithLocation(location: location) != CLSportGPSSignalState.CLSportGPSSignalGood {
            return CLSportPolyLine()
        }
        
        //判断起始位置是否为空
        if startLocation == nil {
            startLocation = location
            return CLSportPolyLine()
        }

        let trackLine: CLSportTrackLine = CLSportTrackLine(startLocation: startLocation!, endLoaction: location)
        startLocation = location
        trackLineArrM.addObjects(from: [trackLine as Any])
        return trackLine.sportPolyLine
    }
    
    /// 返回GPS信号（信号算法）
    ///
    /// - Parameter location: location description
    /// - Returns: GPS信号
    fileprivate func gpsSignalStateWithLocation(location:CLLocation)->CLSportGPSSignalState {
        var signalState:CLSportGPSSignalState?
        if location.horizontalAccuracy < 0 {
            signalState = CLSportGPSSignalState.CLSportGPSSignalStateClose
        }else if location.horizontalAccuracy > 163 {
            signalState = CLSportGPSSignalState.CLSportGPSSignalBad
        }else if location.horizontalAccuracy > 48 {
            signalState = CLSportGPSSignalState.CLSportGPSSignalNormal
        }else {
            signalState = CLSportGPSSignalState.CLSportGPSSignalGood
        }
        
        if signalState != sportGPSSingalState {
            sportGPSSingalState = signalState
            let notification = Notification(name: Notification.Name(rawValue: kGPSSignalChangeNotification), object: nil, userInfo: ["key":signalState!])
            NotificationCenter.default.post(notification)
        }
        return signalState!
    }
    
}

