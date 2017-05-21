//
//  CLSportVC.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/10.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

fileprivate let sportMargin = 50

class CLSportVC: CLBaseVC {
    
    /// 创建播报类
    fileprivate let sportSpraker:CLSportSpearking = CLSportSpearking.sharedSportSpeaking
    
    /// 底部视图
    fileprivate var bottonView:UIView = {
        let bottonView:UIView = UIView()
        bottonView.backgroundColor = UIColor.white
        return bottonView
    }()
    
    /// 开始按钮
    fileprivate var statrButton:UIButton = {
        let btn = UIButton(title: "开始", titleColor: UIColor.white, fontSize: 25, backImage: "btn_start_normal_118x118_", target: self as AnyObject, action: #selector(presentSportingVC(button:)))
        
        return btn
    }()
    
    /// 左上角按钮
    fileprivate var leftTopButton:UIButton = {
        let btn = UIButton(title: "", image: "ic_history_run_normal_54x54_", target: self as AnyObject, action: #selector(leftTopButtonClick(btn:)))
        btn.tag = 1
        return btn
    }()
    
    //添加毛玻璃视图
    fileprivate lazy var visualEffetView: UIVisualEffectView = {
        let blurEffext = UIBlurEffect(style: .dark)
        let visualEffetView = UIVisualEffectView.init(effect: blurEffext)
        visualEffetView.isHidden = true
        return visualEffetView
    }()
    
    /// 跑步按钮
    fileprivate var runButton:UIButton = {
        let btn = UIButton(title: "", image: "ic_history_run_normal_54x54_", target: self as AnyObject, action: #selector(sportStateButtonClick(btn:)))
        btn.tag = 1
        return btn
    }()

    /// 步行按钮
    fileprivate var walkButton:UIButton = {
        let btn = UIButton(title: "", image: "ic_history_walk_normal_54x54_", target: self as AnyObject, action: #selector(sportStateButtonClick(btn:)))
        btn.tag = 2
        return btn
    }()
    
    /// 骑行按钮
    fileprivate var rideButton:UIButton = {
        let btn = UIButton(title: "", image: "ic_history_riding_normal_54x54_", target: self as AnyObject, action: #selector(sportStateButtonClick(btn:)))
        btn.tag = 3
        return btn
    }()
    
    /// X按钮
    fileprivate var closeButton:UIButton = {
        let btn = UIButton(title: "", image: "ic_sport_type_close_44x44_", target: self as AnyObject, action: #selector(sportStateButtonClick(btn:)))
        return btn
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加圆弧动画
        addCircleAnimation()
    }
    
    deinit {
        print("CLSportVC释放啦")
    }
    
    /// 此方法约束已经更新结束
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottonView.layer.cornerRadius = bottonView.bounds.size.width / 2
        bottonView.layer.masksToBounds = true
    }
    
    
}


// MARK: - 页面设置
extension CLSportVC {
    
    override func setupUI() {
        
        view.backgroundColor = UIColor.green
        self.navigationController?.navigationBar.isHidden = true
        
        //添加控件
        view.addSubview(bottonView)
        bottonView.addSubview(statrButton)
        view.addSubview(leftTopButton)
        view.addSubview(visualEffetView)
        
        visualEffetView.contentView.addSubview(runButton)
        visualEffetView.contentView.addSubview(walkButton)
        visualEffetView.contentView.addSubview(rideButton)
        visualEffetView.contentView.addSubview(closeButton)
        
        //设置约束
        bottonView.snp.makeConstraints { (make) in
            make.height.equalTo(view)
            make.size.equalTo(bottonView.snp.height)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(2.3)
            make.centerX.equalTo(view)
        }
        statrButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(bottonView).offset(22)
        }
        leftTopButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(20)
        }
        
        visualEffetView.snp.makeConstraints { (make) in
            make.size.equalTo(UIScreen.main.bounds.size)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(visualEffetView).offset(20)
        }
        runButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(closeButton)
            make.centerY.equalTo(closeButton)
        }
        walkButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(runButton)
            make.centerY.equalTo(runButton)
        }
        rideButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(walkButton)
            make.centerY.equalTo(walkButton)
        }
    }
}

// MARK: - 点击事件处理
extension CLSportVC {
    
    /// 跳转到地图控制器
    @objc fileprivate func presentSportingVC(button: UIButton) {
        
        let counDown = CLTimingView()
        counDown.initWithSourceView(sourceView: button) { (_) in
            
        }
        counDown.delegate = self
        //这里应该添加到tabBarController.view才能覆盖tabbar
        self.tabBarController?.view.addSubview(counDown)
    }
    
    /// 左上角按钮点点击事件
    ///
    /// - Parameter btn: <#btn description#>
    @objc fileprivate func leftTopButtonClick(btn:UIButton) {
        self.tabBarController?.tabBar.isHidden = true
        visualEffetView.isHidden = false
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        runButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(closeButton).offset(30 + closeButton.bounds.size.width)
        }
        walkButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(runButton).offset(30 + closeButton.bounds.size.width)
        }
        rideButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(walkButton).offset(30 + closeButton.bounds.size.width)
        }
        
        closeButton.alpha = 1
        runButton.alpha = 1
        walkButton.alpha = 1
        rideButton.alpha = 1
        
        UIView.animate(withDuration: 1, animations: {
            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            self.visualEffetView.layoutIfNeeded()
        }) { (complete: Bool) in
            if complete == true {
                self.runButton.snp.updateConstraints { (make) in
                    make.centerY.equalTo(self.closeButton).offset(20 + self.closeButton.bounds.size.width)
                }
                self.walkButton.snp.updateConstraints { (make) in
                    make.centerY.equalTo(self.runButton).offset(20 + self.closeButton.bounds.size.width)
                }
                self.rideButton.snp.updateConstraints { (make) in
                    make.centerY.equalTo(self.walkButton).offset(20 + self.closeButton.bounds.size.width)
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self.visualEffetView.layoutIfNeeded()
                })
            }
        }
        
    }
    
    /// 运动状态的按钮
    ///
    /// - Parameter btn: <#btn description#>
    @objc fileprivate func sportStateButtonClick(btn:UIButton) {
        let arr = ["ic_history_run_normal_54x54_.png","ic_history_walk_normal_54x54_.png","ic_history_riding_normal_54x54_.png"]
        if btn.tag >= 1 {
            leftTopButton.setImage(UIImage(named:arr[btn.tag - 1]), for: .normal)
            self.leftTopButton.tag = btn.tag
        }
        runButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(closeButton)
        }
        walkButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(runButton)
        }
        rideButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(walkButton)
        }
        UIView.animate(withDuration: 1, animations: {
            //更新运动类型约束
            self.view.layoutIfNeeded()
            self.closeButton.alpha = 0
            self.runButton.alpha = 0
            self.walkButton.alpha = 0
            self.rideButton.alpha = 0
        }) { (complete: Bool) in
            if complete == true {
                self.tabBarController?.tabBar.isHidden = false
                self.visualEffetView.isHidden = true
            }
            
        }

    }
    
}


extension CLSportVC {
    
    /// 设置圆弧动画
    fileprivate func addCircleAnimation() {
        let circleView1 = CLSportCircleView(frame: view.frame)
        circleView1.centerPoint = CGPoint(x: bottonView.center.x - 10, y: bottonView.center.y - 5)
        circleView1.circleRect = bottonView.frame
        circleView1.backgroundColor = UIColor.clear
        view.insertSubview(circleView1, at: 0)
        let circleView2 = CLSportCircleView(frame: view.frame)
        circleView2.centerPoint = CGPoint(x: bottonView.center.x + 10, y: bottonView.center.y - 3)
        circleView2.circleRect = bottonView.frame
        circleView2.backgroundColor = UIColor.clear
        view.insertSubview(circleView1, at: 0)
        basicAnimationWithView(circleView: circleView1, duration: 5)
        basicAnimationWithView(circleView: circleView2, duration: 3)
        
    }
    
    /// 开启动画
    ///
    /// - Parameters:
    ///   - circleView: 线条
    ///   - duration: 时间
    fileprivate func basicAnimationWithView(circleView:CLSportCircleView,duration:Float) {
        let anmtion = CABasicAnimation(keyPath: "position.y")
        anmtion.fromValue = circleView.center.y
        anmtion.toValue = circleView.center.y - 5
        anmtion.duration = CFTimeInterval(duration)
        anmtion.autoreverses = true
        anmtion.fillMode = kCAFillModeForwards
        anmtion.isRemovedOnCompletion = false
        anmtion.repeatCount = MAXFLOAT
        circleView.layer.add(anmtion, forKey: "anmtion")
    }
    
    
}

extension CLSportVC:CLTimingViewDelegate {
    
    func endTimingView(TimingView: CLTimingView) {
        let sportingVC: CLsportSportingVC = CLsportSportingVC()
        sportingVC.sportType = CLSportType(rawValue: self.leftTopButton.tag)
        sportingVC.view.backgroundColor = UIColor.blue
        sportSpraker.initWithDistanceUnit(distanceUnit: 1, sportType: CLSportType(rawValue: self.leftTopButton.tag)!)
        sportingVC.sportSpraker = sportSpraker
        //开始播报
        self.sportSpraker.sportStart()
        
        self.present(sportingVC, animated: true, completion: nil)
    }
    
}

