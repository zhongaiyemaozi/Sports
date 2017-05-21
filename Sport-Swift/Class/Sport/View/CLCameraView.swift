//
//  CLCameraView.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/18.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

class CLCameraView: UIView {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        backgroundColor = UIColor.clear
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let backPath:UIBezierPath = UIBezierPath(rect: bounds)
        let color = UIColor.cl_colorWithHex(hex: 0x24282e)
        color.setFill()
        backPath.fill()
        let linePath = UIBezierPath()
        linePath.lineWidth = 0.5
        if self.subviews[0].frame.origin.x > 0 {
            linePath.move(to: CGPoint(x: bounds.size.width, y: 0))
            linePath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        }else {
            linePath.move(to: CGPoint(x: 0, y: 0))
            linePath.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        }
        let lineColor = UIColor(white: 0.05, alpha: 1)
        lineColor.setStroke()
        linePath.stroke()
        UIGraphicsGetCurrentContext()?.clear(subviews[0].frame.insetBy(dx: 1, dy: 1))
        
        
    }
 
}
