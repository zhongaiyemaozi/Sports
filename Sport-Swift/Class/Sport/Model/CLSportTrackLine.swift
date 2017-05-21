//
//  CLSportTrackLine.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/11.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

class CLSportTrackLine: NSObject {
    //起始location
    fileprivate var trackStartLocation: CLLocation?
    // 结束时location
    fileprivate var trackEndLoaction: CLLocation?
    //单次轨迹线条速度
    var speed: Float {
        get {
            
            return Float(((self.trackStartLocation?.speed)! + (self.trackEndLoaction?.speed)!) / 2 * 3.6)
        }
    }
    //单次轨迹线条时间
    var time: Float {
        get {
            return Float((self.trackEndLoaction?.timestamp)!.timeIntervalSince((self.trackStartLocation?.timestamp)!))
        }
    }
    //单次轨迹线条距离
    var distance: Float {
        get {
            return Float((self.trackStartLocation?.distance(from: self.trackEndLoaction!))! * 0.001)
        }
    }

    
    
    var sportPolyLine:CLSportPolyLine {
        get {
            
            var lineCoordinates: [CLLocationCoordinate2D] = [
                CLLocationCoordinate2D(latitude: (self.trackStartLocation?.coordinate.latitude)!, longitude: (self.trackStartLocation?.coordinate.longitude)!),
                CLLocationCoordinate2D(latitude: (self.trackEndLoaction?.coordinate.latitude)!, longitude: (self.trackEndLoaction?.coordinate.longitude)!)]
            
            
            let factor: Float = 9.0
            
            let color = UIColor(red: CGFloat((self.speed * factor) / 255.0), green: 1, blue: 0, alpha: 1)
            
            let polyline: CLSportPolyLine = CLSportPolyLine.polylineWithCoordinates(coordinates: &lineCoordinates, count: lineCoordinates.count, color: color)
            
            return polyline
        }
    }
    
    init(startLocation:CLLocation,endLoaction:CLLocation) {
        
        self.trackStartLocation = startLocation
        self.trackEndLoaction = endLoaction
        
        
    }
    
    
}
