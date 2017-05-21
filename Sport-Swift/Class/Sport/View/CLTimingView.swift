//
//  CLTimingView.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/21.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

/// 设置代理
protocol CLTimingViewDelegate {
    
    
    /// 完成后回调
    ///
    /// - Parameter TimingView: TimingView
    func endTimingView(TimingView:CLTimingView)
}

fileprivate var i = 3

class CLTimingView: UIView {
    //设置代理
    var delegate:CLTimingViewDelegate?
    
    fileprivate var sourceView:UIView?
    //闭包回调
    fileprivate var complete = {
        
        (complete : Void) in
        
    }
    
    /// 倒计时文本
    fileprivate var label:UILabel?
    
    /// 倒计时透明圆形视图
    fileprivate var circleView:UIView?
    
    /// 创建倒计时动画视图
    ///
    /// - Parameters:
    ///   - sourceView: 来源视图（以哪一个视图作为中心点开始放大）
    ///   - completion: 倒计时完成回调
    func initWithSourceView(sourceView:UIView,completion : (Void) ->()){
        self.frame = UIScreen.main.bounds
        
        self.sourceView = sourceView
        self.complete(completion())
        //1.添加CAShapeLayer图层动画
        addLayerAnimation()
    }
    
    deinit {
        print("倒计时动画被移除")
    }
    
}


extension CLTimingView {
    
    /// 添加CAShapeLayer图层动画
    fileprivate func addLayerAnimation() {
        let shapeLayer = CAShapeLayer()
        let startRect = sourceView?.convert((sourceView?.bounds)!, to: self)
        let startBezierPath = UIBezierPath(ovalIn: startRect!)
        let sWidth = self.frame.size.width
        let sHeight = self.frame.size.height
        let endRadius = sqrt(sWidth*sWidth + sHeight*sHeight)
        let endRect = startRect?.insetBy(dx: -endRadius, dy: -endRadius)
        let endPath = UIBezierPath(ovalIn: endRect!)
        shapeLayer.fillColor = UIColor.cl_rgbColor(red: 100, green: 188, blue: 127).cgColor
        shapeLayer.path = startBezierPath.cgPath
        layer.addSublayer(shapeLayer)
        animationWithStartPath(startPath: startBezierPath, endPath: endPath, shapeLayer: shapeLayer)
        after(1) {
            self.setupUI()
            self.timingAnimation()
        }
        
    }
    
    /// 创建控件
    fileprivate func setupUI() {
        
        circleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        circleView?.center = center
        circleView?.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        circleView?.layer.masksToBounds = true
        circleView?.layer.cornerRadius = (circleView?.bounds.size.width)! / 2
        addSubview(circleView!)
        
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label?.center = center
        label?.font = UIFont(name: "arial", size: 100)
        label?.textAlignment = .center
        label?.textColor = UIColor.white
        addSubview(label!)
    }
    
    /// 倒计时动画
    fileprivate func timingAnimation() {
        
        if i == 0 {
            i = 3
            complete()
            self.delegate?.endTimingView(TimingView: self)
            removeFromSuperview()
            return
        }
        label?.text = "\(i)"
        label?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        label?.alpha = 0
        circleView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        circleView?.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.label?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.label?.alpha = 1
            self.circleView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.circleView?.alpha = 1
            
        }) { (_) in
            self.circleView?.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.label?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                self.label?.alpha = 0.5
            }, completion: { (_) in
                
                i -= 1
                self.timingAnimation()
                
            })
        }
        
    }
    
    /// 执行动画
    ///
    /// - Parameters:
    ///   - startPath: <#startPath description#>
    ///   - endPath: <#endPath description#>
    ///   - shapeLayer: <#shapeLayer description#>
    fileprivate func animationWithStartPath(startPath: UIBezierPath,endPath:UIBezierPath,shapeLayer:CAShapeLayer) {
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.duration = 1
        basicAnimation.fromValue = startPath.cgPath
        basicAnimation.toValue = endPath.cgPath
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
}










