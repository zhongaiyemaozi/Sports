//
//  CLGPSButton.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/15.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

class CLGPSButton: UIButton {
    
    /// 遍历构造器(创建按钮可以添加点击事件)
    ///
    /// - Parameters:
    ///   - title: 按钮文字
    ///   - titleColor: 文字颜色
    ///   - fontSize: 文字大小
    ///   - image: 图片名字
    ///   - backImage: 背景图片名字
    ///   - target: target
    ///   - action: action
    ///   - event: UIControlEvents
    convenience init(title: String?,
                     titleColor: UIColor = UIColor.darkGray,
                     fontSize: CGFloat = 14,
                     image: String? = nil,
                     backImage: String? = nil,
                     target: AnyObject? = nil,
                     action: Selector? = nil,
                     event: UIControlEvents = .touchUpInside){
        self.init()
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        //传了图片才设置
        if let image = image {
            
            self.setImage(UIImage(named: image), for: .normal)
            self.setImage(UIImage(named: "\(image)_highlighted"), for: .highlighted)
        }
        //传了图片才设置背景图片
        if let backImage = backImage {
            self.setBackgroundImage(UIImage(named: backImage), for: .normal)
            self.setBackgroundImage(UIImage(named: "\(backImage)_highlighted"), for: .highlighted)
        }
        //添加事件
        if let target = target, let action = action {
            self.addTarget(target, action: action, for: event)
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(sportGPSSignalState), name: NSNotification.Name(rawValue: kGPSSignalChangeNotification), object: nil)
        
        
        //设置属性
        self.backgroundColor = UIColor.black
        self.alpha = 0.4
        self.bounds.size = CGSize(width: 0, height: 24)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}


extension CLGPSButton {
    
    /// 通知调用的方法
    @objc fileprivate func sportGPSSignalState(notification:Notification) {
        
        let isgnalState = notification.userInfo?["key"] as! CLSportGPSSignalState
        //图片名字
        var imageStr:String?
        if self.tag == 1 {
            imageStr = "ic_sport_gps_connect"
        }else if self.tag == 2 {
            imageStr = "ic_sport_gps_map_connect"
        }
        //GPS图片旁边的名字
        var titleStr:String?
        if isgnalState == CLSportGPSSignalState.CLSportGPSSignalStateClose {
            titleStr = "  GPS已断开  "
        }else if isgnalState == CLSportGPSSignalState.CLSportGPSSignalBad {
            titleStr = "  建议绕开高楼大厦  "
        }else if isgnalState == CLSportGPSSignalState.CLSportGPSSignalNormal {
            titleStr = "  GSP信号较好  "
        }else if isgnalState == CLSportGPSSignalState.CLSportGPSSignalGood {
            titleStr = "  GPS信号很好  "
        }
        self.setImage(UIImage(named:String(format: "%@_%zd", imageStr!,isgnalState.rawValue - 1)), for: .normal)
        self.setTitle(titleStr, for: .normal)
        //重新布局
        self.layoutIfNeeded()
        //出现动画
        self.alpha = 0
        UIView.animate(withDuration: 0.5) { 
            
            self.alpha = 1
        };
    }
    
}


