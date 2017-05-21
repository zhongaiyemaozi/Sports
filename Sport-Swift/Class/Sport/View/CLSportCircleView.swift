//
//  CLSportCircleView.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/21.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

class CLSportCircleView: UIView {
    
    /// 圆的参考外接矩形（绘制的圆就是该矩形的内切圆）
    var circleRect:CGRect?
    
    /// 圆心的坐标（如果不赋值，则表示圆心坐标就是外接矩形的内切圆的圆心）
    var centerPoint:CGPoint?
    
    
    override func draw(_ rect: CGRect) {
        
        /// 获取当前绘图的上下文
        let contextRef = UIGraphicsGetCurrentContext()
        //设置线条宽度
        contextRef?.setLineWidth(1)
        //设置线条颜色
        contextRef!.setStrokeColor(UIColor(white: 0.9, alpha: 0.8).cgColor)
        //4.开始画圆
        /**
         第一个参数：圆心x坐标
         第二个参数：圆心y坐标
         第三个参数：圆的半径
         第四个参数：圆弧起始点弧度
         第五个参数：圆弧结束点弧度
         第六个参数：圆弧方向  false：顺时针 true：顺时针
         */
        contextRef?.addArc(center: centerPoint!, radius: (circleRect?.size.width)! / 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        //画边框圆
        contextRef?.strokePath()
    }
 

}
