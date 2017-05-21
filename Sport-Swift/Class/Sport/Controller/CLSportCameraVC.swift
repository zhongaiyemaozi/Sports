//
//  CLSportCameraVC.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/17.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

class CLSportCameraVC: CLBaseVC {
    
    /// 相机工具类属性
    var photoRecorder:CLPhotoRecorder? = nil
    
    /// 分享的图片
    var shareImage: UIImage? = nil
    
    /// 懒加载右边部分视图
    fileprivate lazy var rightView：CLCameraView = { () -> CLCameraView in
        let view = CLCameraView()
        
        return view
    }()
    
    /// 懒加载左边部分视图
    fileprivate lazy var leftView：CLCameraView = { () -> CLCameraView in
        let view = CLCameraView()
        
        return view
    }()
    
    /// 懒加载上半边视图
    fileprivate lazy var topView：UIView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    /// 懒加载下半部分视图
    fileprivate lazy var bottonView：UIView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    
    //懒加载dismiss按钮
    fileprivate lazy var dismissButton:UIButton = {
        
        let btn = UIButton(title: "", image: "ic_waterprint_close", target: self, action: #selector(dismissCameraVC))
        return btn
    }()
    
    //懒加载相机按钮按钮
    fileprivate lazy var cameraButton:UIButton = {
        
        let btn = UIButton(title: "", backImage: "ic_waterprint_shutter", target: self, action: #selector(cameraButtonClick(button:)))
        btn.sizeToFit();
        return btn
    }()
    
    //懒加载相机切换按钮
    fileprivate lazy var settingButton:UIButton = {
        
        let btn = UIButton(title: "", image: "ic_waterprint_revolve", target: self, action: #selector(cameraButtonswitchover))
        return btn
    }()
    
    //懒加载分享按钮
    fileprivate lazy var shareButton:UIButton = {
        
        let btn = UIButton(title: "", image: "ic_waterprint_share", target: self, action: #selector(sharedButtonClick))
        btn.isHidden = true
        return btn
    }()
    
    /// 添加左边图片
    fileprivate lazy var leftImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_shutter_center_left"))
        return imageView
    }()
    
    /// 添加右边图片
    fileprivate lazy var rightImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_shutter_center_right"))
        return imageView
    }()
    
    /// 添加水印图片
    fileprivate lazy var watermarkImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_waterprint_action_oriented"))
        return imageView
    }()
    
    /// 添加水印文字
    fileprivate lazy var waterLabel:UILabel = {
       let label = UILabel(title: "夜猫子", textColor: UIColor.white, fontSize: 25, alignment: .center)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    /// 约束已经完成布局
    override func viewDidLayoutSubviews() {
         super.viewWillLayoutSubviews()
        if photoRecorder == nil {
            photoRecorder = CLPhotoRecorder()
            //设置视图
            photoRecorder?.initWithPreView(preView: topView：UIView)
            
            // MARK: - 设置代理
            photoRecorder?.delegate = self
        }
    }
    
    /// 隐藏电池栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

// MARK: - 页面设置
extension CLSportCameraVC {
    //页面布局
    override func setupUI() {
        //添加子视图
        view.addSubview(topView：UIView)
        view.addSubview(bottonView：UIView)
        
        bottonView：UIView.addSubview(cameraButton)
        bottonView：UIView.addSubview(dismissButton)
        bottonView：UIView.addSubview(settingButton)
        bottonView：UIView.addSubview(shareButton)
        
        topView：UIView.addSubview(leftView：CLCameraView)
        topView：UIView.addSubview(rightView：CLCameraView)
        
        leftView：CLCameraView.addSubview(leftImageView)
        rightView：CLCameraView.addSubview(rightImageView)
        topView：UIView.addSubview(watermarkImageView)
        
        topView：UIView.addSubview(waterLabel)
        
        //设置约束
        
        bottonView：UIView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(120)
        }
        topView：UIView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(bottonView：UIView.snp.top)
        }
        
        cameraButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottonView：UIView.snp.centerX)
            make.centerY.equalTo(bottonView：UIView.snp.centerY)
        }
        dismissButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cameraButton)
            make.left.equalTo(bottonView：UIView).offset(25)
        }
        settingButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cameraButton)
            make.right.equalTo(bottonView：UIView).offset(-25)
        }
        shareButton.snp.makeConstraints { (make) in
            make.edges.equalTo(settingButton)
        }
        
        leftView：CLCameraView.snp.makeConstraints { (make) in
            make.width.equalTo(Screen_Width / 2)
            make.height.equalTo(topView：UIView)
            make.right.equalTo(view.snp.left).offset(-(Screen_Width / 2 + 52))
        }
        rightView：CLCameraView.snp.makeConstraints { (make) in
            make.size.equalTo(leftView：CLCameraView)
            make.left.equalTo(view.snp.right).offset((Screen_Width / 2 + 52))
        }
        
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftView：CLCameraView)
            make.right.equalTo(leftView：CLCameraView).offset(leftImageView.bounds.size.width / 2)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftImageView)
            make.left.equalTo(rightView：CLCameraView).offset(-rightImageView.bounds.size.width / 2)
        }
        
        waterLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(bottonView：UIView.snp.top).offset(-20)
        }
        watermarkImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(waterLabel)
            make.bottom.equalTo(waterLabel.snp.top).offset(-8)
        }
        
    }
    
}



// MARK: - 事件处理
extension CLSportCameraVC {
    
    /// dismiss控制器
    @objc fileprivate func dismissCameraVC() {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 相机按钮点击事件
    @objc fileprivate func cameraButtonClick(button:UIButton) {
        //启动效果
        cameraAnmiationIsbold(isbold: true)
        //延迟执行
        after(Int(1)) {
            
            self.cameraAnmiationIsbold(isbold: false)
        }
        //拍照
        photoRecorder?.capture { (comImage : UIImage) -> () in
            self.shareImage = comImage
            print("成功")
        }
        //相机、切换按钮动画
        captureAnimationCaptureButton(btn: button)
    }
    
    /// 相机按钮前后切换事件
    @objc fileprivate func cameraButtonswitchover() {
        photoRecorder?.switchCamera()
        
    }
    
    /// 分享照片调用的方法
    @objc fileprivate func sharedButtonClick() {
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "夜猫子",
                                          images : shareImage,
                                          url : NSURL(string:"http://mob.com") as URL!,
                                          title : "https://github.com/zhongaiyemaozi",
                                          type : SSDKContentType.image)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.typeWechat, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
        
    }
}


// MARK: - 动画效果
extension CLSportCameraVC {
    //动画效果
    fileprivate func cameraAnmiationIsbold(isbold:Bool) {
        view.isUserInteractionEnabled = false
        if isbold {
            leftView：CLCameraView.snp.updateConstraints({ (make) in
                make.right.equalTo(view.snp.left).offset(Screen_Width / 2)
            })
            rightView：CLCameraView.snp.updateConstraints({ (make) in
                make.left.equalTo(view.snp.right).offset(-Screen_Width / 2)
            })
            
        }else {
            
            leftView：CLCameraView.snp.updateConstraints({ (make) in
                make.right.equalTo(view.snp.left).offset(-(Screen_Width / 2 + 52))
            })
            rightView：CLCameraView.snp.updateConstraints({ (make) in
                make.left.equalTo(view.snp.right).offset((Screen_Width / 2 + 52))
            })
            
        }
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    /// 拍摄动画
    ///
    /// - Parameter btn: 动画
    fileprivate func captureAnimationCaptureButton(btn:UIButton) {
        let empty = btn.currentTitle == "" ? true : false
        if empty == true {
            UIView.transition(with: btn, duration: 0.3, options: .transitionFlipFromLeft, animations: { 
                btn.setTitle("😘", for: .normal)
            }, completion: { (_) in
                
                
            })
            //切换摄像头按钮翻转
            UIView .transition(with: settingButton, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                self.settingButton.isHidden = true
            }, completion: { (_) in
                //进制拍摄
                self.photoRecorder?.stopCamrea()
            })
            UIView .transition(with: shareButton, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                //显示分享按钮
                self.shareButton.isHidden = false
            }, completion: { (_) in
                
            })
        }else {
            UIView.transition(with: btn, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                btn.setTitle("", for: .normal)
            }, completion: { (_) in
                
                
            })
            //切换摄像头按钮翻转
            UIView .transition(with: settingButton, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                self.settingButton.isHidden = false
            }, completion: { (_) in
                self.photoRecorder?.startCamera()
            })
            UIView .transition(with: shareButton, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                //显示分享按钮
                self.shareButton.isHidden = true
            }, completion: { (_) in
                
            })

        }
        
    }
    
    
}

// MARK: - CLPhotoRecorderDelegate代理
extension CLSportCameraVC:CLPhotoRecorderDelegate {
    
    /// 代理
    ///设置水印绘图代理，此方法把水印图片绘制进去
    /// - Parameter waterImage: <#waterImage description#>
    func phontWaterImage(waterImage: CLPhotoRecorder) {
        watermarkImageView.image?.draw(in: watermarkImageView.frame)
        waterLabel.attributedText?.draw(in: waterLabel.frame)
    }
    
}







