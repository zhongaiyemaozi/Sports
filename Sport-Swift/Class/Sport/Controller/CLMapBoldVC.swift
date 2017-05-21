//
//  CLMapBoldVC.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/15.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

class CLMapBoldVC: CLBaseVC {
    
    /// 左边按钮视图
    fileprivate var mapButtonLeft:UIButton = {
        let mapButton = UIButton(title: "", image: "ic_sport_gps_map_flatmode",target: self as AnyObject, action: #selector(mapButtonClick(button:)))
        mapButton.tag = 1
        return mapButton
    }()
    
    /// 中间视图按钮
    fileprivate var mapButtonCenter:UIButton = {
        let mapButton = UIButton(title: "", image: "ic_sport_gps_map_realmode", target: self as AnyObject, action: #selector(mapButtonClick(button:)))
        mapButton.tag = 2
        return mapButton
    }()
    
    /// 右边视图按钮
    fileprivate var mapButtonRight:UIButton = {
        let mapButton = UIButton(title: "", image: "ic_sport_gps_map_mixmode", target: self as AnyObject, action: #selector(mapButtonClick(button:)))
        mapButton.tag = 3
        return mapButton
    }()
    
    //种类
    var currentIndex:NSInteger = 0
    //闭包回调
    var complete = {
        
        (complete : NSInteger) in
        
    }
    //记录当前点击的按钮
    fileprivate var mapButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn:UIButton = view.viewWithTag(currentIndex + 1) as! UIButton
        btn.isSelected = true
        mapButton = btn
        
        
    }
    
    deinit {
        print("CLMapBoldVC释放啦")
    }
}

extension CLMapBoldVC {
    //页面布局
    override func setupUI() {
        //添加按钮
        view.addSubview(mapButtonCenter)
        view.addSubview(mapButtonLeft)
        view.addSubview(mapButtonRight)
        //设置约束
        mapButtonLeft.snp.makeConstraints { (make) in
            make.left.top.equalTo(view).offset(8)
        }
        mapButtonCenter.snp.makeConstraints { (make) in
            make.top.equalTo(mapButtonLeft)
            make.left.equalTo(mapButtonLeft.snp.right).offset(8)
        }
        mapButtonRight.snp.makeConstraints { (make) in
            make.top.equalTo(mapButtonCenter)
            make.left.equalTo(mapButtonCenter.snp.right).offset(8)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CLMapBoldVC {
    
    /// 按钮点击的事件
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func mapButtonClick(button:UIButton) {
        
        if self.mapButton != nil {
            
            complete(button.tag)
        }
        
    }
    
}



