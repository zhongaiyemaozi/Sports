//
//  CLSportPolyLine.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/11.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

class CLSportPolyLine: MAPolyline {
    //添加颜色属性
    var color: UIColor?
    
    /**
     *  根据经纬度坐标数据生成多段线
     *
     *  @param coords 经纬度坐标数据,coords对应的内存会拷贝,调用者负责该内存的释放
     *  @param count  经纬度坐标个数
     *  @param color  添加一个属性
     *  @return 生成的多段线
     */
    class func polylineWithCoordinates(coordinates: UnsafeMutablePointer<CLLocationCoordinate2D>!, count: Int,color:UIColor) -> CLSportPolyLine {
        
        let line = CLSportPolyLine(coordinates: coordinates, count: UInt(count))
        line?.color = color
        
        return line!
    }
    
    
}
