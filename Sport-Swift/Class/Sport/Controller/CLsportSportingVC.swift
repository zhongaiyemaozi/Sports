//
//  CLsportSportingVC.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/10.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

fileprivate let margin: CGFloat = 20

class CLsportSportingVC: CLBaseVC {
    
    /// 运动类型枚举
    var sportType: CLSportType?
    //运动状态枚举
    var sportState: CLSprotState = CLSprotState.CLSprotStateContuter
    //底部视图View
    fileprivate var bottonView: UIView?
    //地图视图
    var mapMapVC: CLSportMapVC?
    
    /// 语音播报类
    var sportSpraker:CLSportSpearking? = nil
    
    /// 距离（公里的值）
    fileprivate lazy var kmLabel:UILabel = {
       let label = UILabel(title: "0.00", textColor: UIColor.white, fontSize: 90)
        return label
    }()
    
    /// 时长的值
    fileprivate lazy var timeLabel:UILabel = {
        let label = UILabel(title: "00:00:00", textColor: UIColor.white, fontSize: 45)
        return label
    }()
    
    /// 时长的值
    fileprivate lazy var avgLabel:UILabel = {
        let label = UILabel(title: "0.00", textColor: UIColor.white, fontSize: 45)
        return label
    }()
    
    /// 距离（公里）
    fileprivate lazy var kmAdnFixLabel:UILabel = {
        let label = UILabel(title: "距离(公里)", textColor: UIColor.cl_colorWithHex(hex: 0x8b9eaa), fontSize: 15)
        return label
    }()
    
    /// 时长
    fileprivate lazy var timeAndFixLabel:UILabel = {
        let label = UILabel(title: "距离(公里)", textColor: UIColor.cl_colorWithHex(hex: 0x8b9eaa), fontSize: 15)
        return label
    }()
    
    /// 平均速度(公里/时)
    fileprivate lazy var avgAndFixLabel:UILabel = {
        let label = UILabel(title: "平均速度(公里/时)", textColor: UIColor.cl_colorWithHex(hex: 0x8b9eaa), fontSize: 15)
        return label
    }()
    
    //懒加载GPS按钮
    fileprivate lazy var GPSButton:UIButton = {
        
        let btn = CLGPSButton(title: "  GPS信号好  ",  image: "ic_sport_gps_connect_3")
        btn.tag = 1
        return btn
    }()
    
    //相机按钮
    fileprivate lazy var cameraButton:UIButton = {
        
        let btn = UIButton(title: "",  image: "ic_sport_camera", target: self, action: #selector(presectCameraVC))
        return btn
    }()
    
    //解锁开锁按钮
    fileprivate lazy var lockButton:UIButton = {
        
        let btn = UIButton(title: "",  image: "ic_sport_lock_1")
        return btn
    }()
    
    //设置按钮
    fileprivate lazy var SettingButton:UIButton = {
        
        let btn = UIButton(title: "",  image: "ic_sport_settings")
        return btn
    }()
    
    //结束按钮
    fileprivate lazy var finishButton:UIButton = {
        
        let btn = UIButton(title: "", image: "ic_sport_finish", target: self, action: #selector(presentSportingVC(button:)))
        btn.tag = 3
        btn.backgroundColor = UIColor.red
        btn.sizeToFit();
        btn.layer.cornerRadius = btn.bounds.size.width / 2
        btn.layer.masksToBounds = true;
        return btn
    }()
    
    //继续按钮
    fileprivate lazy var continueButton:UIButton = {
        let btn = UIButton(title: "", image: "ic_sport_continue", target: self, action: #selector(presentSportingVC(button:)))
        btn.backgroundColor = UIColor.cl_colorWithHex(hex: 0x33d54e)
        btn.tag = 1
        btn.sizeToFit();
        btn.layer.cornerRadius = btn.bounds.size.width / 2
        btn.layer.masksToBounds = true;
        return btn
    }()
    
    //暂停按钮
    fileprivate lazy var pauseButton:UIButton = {
        
        let btn = UIButton(title: "", image: "ic_sport_pause", target: self, action: #selector(presentSportingVC(button:)))
        btn.backgroundColor = UIColor.cl_colorWithHex(hex: 0x33d54e)
        btn.tag = 2
        btn.sizeToFit();
        btn.layer.cornerRadius = btn.bounds.size.width / 2
        btn.layer.masksToBounds = true;
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    deinit {
        print("CLsportSportingVC释放啦")
    }
    
}

extension CLsportSportingVC {
    
    override func setupUI() {
        
        //添加地图控制器
        let mapVC = CLSportMapVC()
        self.mapMapVC = mapVC
        self.mapMapVC?.view.bounds = self.view.bounds
        //设置代理
        mapVC.delegate = self

        let mapButtonClick: UIButton = UIButton(title: "",image: "ic_sport_map", target: self, action: #selector(mapButtonPresentVC))
        
        view.addSubview(mapButtonClick)
        
        mapButtonClick.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(margin)
            make.right.equalTo(view).offset(-margin)
        }
        
        
        //常见模型
        let trackModel: CLSportTrackingModel = CLSportTrackingModel(type: sportType!, state: sportState)
        
        mapVC.trackModel = trackModel
        
        //添加GPS按钮
        view.addSubview(GPSButton)
        //设置约束
        GPSButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(margin)
        }
        //添加图片控件
        bottonAddButton()
        //添加渐变图层
        configBackGroundColor()
    }
    
    /// 添加图片控件
    func bottonAddButton() {
        //添加控件
        view.addSubview(kmAdnFixLabel)
        view.addSubview(timeAndFixLabel)
        view.addSubview(avgAndFixLabel)
        
        view.addSubview(kmLabel)
        view.addSubview(timeLabel)
        view.addSubview(avgLabel)
        
        view.addSubview(cameraButton)
        view.addSubview(lockButton)
        view.addSubview(SettingButton)
        
        view.addSubview(finishButton)
        view.addSubview(continueButton)
        view.addSubview(pauseButton)
        //设置约束
        //label的约束
        kmLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.55)
            make.centerX.equalTo(view)
        }
        kmAdnFixLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(kmLabel)
            make.top.equalTo(kmLabel.snp.bottom).offset(4)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(kmAdnFixLabel.snp.bottom).offset(46.5)
            make.centerX.equalTo(kmLabel).multipliedBy(0.5)
        }
        timeAndFixLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.centerX.equalTo(timeLabel)
        }
        avgLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel)
            make.centerX.equalTo(kmLabel).multipliedBy(1.5)
        }
        avgAndFixLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(avgLabel)
            make.top.equalTo(timeAndFixLabel)
        }
        //相机、解锁、设置按钮约束
        cameraButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(11)
            make.bottom.equalTo(view).offset(-12)
        }
        lockButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(cameraButton)
        }
        SettingButton.snp.makeConstraints { (make) in
            make.right.equalTo(-11)
            make.top.equalTo(lockButton)
        }
        //暂停、继续、结束按钮
        finishButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(lockButton.snp.top).offset(-37)
            make.centerX.equalTo(view)
        }
        continueButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(lockButton.snp.top).offset(-37)
            make.centerX.equalTo(view)
        }
        pauseButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(lockButton.snp.top).offset(-37)
            make.centerX.equalTo(view)
        }
        
    }
    
    /// 设置背景渐变颜色
    fileprivate func configBackGroundColor() {

        let gradientLayer = CAGradientLayer()
        gradientLayer.bounds = view.bounds
        gradientLayer.position = view.center
        let color1 = UIColor.cl_colorWithHex(hex: 0x0e1428).cgColor
        let color2 = UIColor.cl_colorWithHex(hex: 0x406479).cgColor
        let color3 = UIColor.cl_colorWithHex(hex: 0x406578).cgColor
        gradientLayer.colors = [color1,color2,color3]
        gradientLayer.locations = [0,0.6,1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}

extension CLsportSportingVC {
    
    /// 继续、暂停、结束按钮点击方法
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func presentSportingVC(button: UIButton) {
        
        mapMapVC?.trackModel?.sportState = CLSprotState(rawValue: button.tag)!
        
        if CLSprotState(rawValue: button.tag)! == CLSprotState.CLSprotStateContuter {
            foldAnimation(isFold: true)
        }else if CLSprotState(rawValue: button.tag)! == CLSprotState.CLSprotStatePause {
            foldAnimation(isFold: false)
        }else {
            dismiss(animated: true, completion: nil)
        }
        //播报
        self.sportSpraker?.sportStateChange(state: CLSprotState(rawValue: button.tag)!)
    }
    
    /// 跳转地图控制器
    @objc fileprivate func mapButtonPresentVC(button: UIButton) {
        mapMapVC?.mapView?.compassOrigin = CGPoint(x: button.center.x - (mapMapVC?.mapView?.compassSize.width)! / 2 , y: button.center.y - (mapMapVC?.mapView?.compassSize.height)! / 2)
        
        present(mapMapVC!, animated: true, completion: nil);
        
    }
    
    /// 跳转到相机控制器
    @objc fileprivate func presectCameraVC() {
        present(CLSportCameraVC(), animated: true, completion: nil)
    }
    
    
}

extension CLsportSportingVC {
    
    /// 动画执行效果
    ///
    /// - Parameter isFold: 折叠或是展开
    fileprivate func foldAnimation(isFold:Bool) {
        
        let width = pauseButton.bounds.size.width
        
        if isFold {
            continueButton.snp.updateConstraints({ (make) in
                make.centerX.equalTo(view)
            })
            finishButton.snp.updateConstraints({ (make) in
                make.centerX.equalTo(view)
            })
        }else {
            continueButton.snp.updateConstraints({ (make) in
                make.centerX.equalTo(view).offset(-(width + 5))
            })
            finishButton.snp.updateConstraints({ (make) in
                make.centerX.equalTo(view).offset(width + 5)
            })
            pauseButton.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.view.layoutIfNeeded()
        }) { (finishe) in
            if isFold{
                self.pauseButton.isHidden = false
            }
        }
        
    }

}


// MARK: - CLSportMapVCDelegate代理，改变数据
extension CLsportSportingVC: CLSportMapVCDelegate {
    
    func sportMapVC(mapVC: CLSportMapVC, sportTrackingModel: CLSportTrackingModel) {
        kmLabel.text = String(format: "%.2f", (sportTrackingModel.totalDistance))
        timeLabel.text = sportTrackingModel.totalTimeStr
        avgLabel.text = String(format: "%.2f", (sportTrackingModel.avgSpeed))
        self.sportSpraker?.reportDistance(distance: sportTrackingModel.totalDistance, time: sportTrackingModel.totalTime, avgSpeed: sportTrackingModel.avgSpeed)
    }
    
}


