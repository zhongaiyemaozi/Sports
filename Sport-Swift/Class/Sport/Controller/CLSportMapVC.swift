//
//  CLSportMapVC.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/10.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit

//三次滤镜算法
fileprivate var index2: NSInteger = 0

fileprivate let margin = 10

//设置代理
protocol CLSportMapVCDelegate:NSObjectProtocol {
    //代理方法
    func sportMapVC(mapVC:CLSportMapVC,sportTrackingModel:CLSportTrackingModel)
    
}


class CLSportMapVC: CLBaseVC {
    
    //设置代理属性
    var delegate:CLSportMapVCDelegate?
    
    //模态自定义动画模型
    fileprivate var presentAnmation:CLCustomPresentAnnimation? = nil
    
    //模型属性
    var trackModel: CLSportTrackingModel? = nil
    
    //起始CLLocation
    fileprivate var startLocation: CLLocation?
    //地图视图
    var mapView: MAMapView? = nil
    
    //添加毛玻璃视图
    fileprivate lazy var visualEffetView: UIVisualEffectView = {
        let blurEffext = UIBlurEffect(style: .light)
        
        let visualEffetView = UIVisualEffectView.init(effect: blurEffext)
        return visualEffetView
    }()
    
    /// 懒加载显示距离的label
    fileprivate lazy var kmLabel:UILabel = {
        let label = UILabel(title: "0.00", textColor: UIColor.black,fontSize: 25,alignment: .center)
        return label
    }()
    
    /// 懒加载显示时间的label
    fileprivate lazy var timeLabel:UILabel = {
        let label = UILabel(title: "00:00:00", textColor: UIColor.black,fontSize: 25, alignment: .center)
        return label
    }()
    
    /// 懒加载距离（公里）
    fileprivate lazy var distanceLabel:UILabel = {
        let label = UILabel(title: "距离(公里)", textColor: UIColor.darkGray,fontSize: 16, alignment: .center)
        return label
    }()
    
    /// 懒加载时长
    fileprivate lazy var durationLabel:UILabel = {
        let label = UILabel(title: "时长", textColor: UIColor.darkGray,fontSize: 16,  alignment: .center)
        return label
    }()
    //懒加载disMiss按钮
    fileprivate lazy var dismissButtonClick:UIButton = {
        let btn = UIButton(title: "",  image: "ic_sport_gps_map_close", target: self, action: #selector(dismissButtonClick(button:)))
        return btn
    }()
    
    //懒加载切换地图按钮
    fileprivate lazy var selectMapButton:UIButton = {
        let btn = UIButton(title: "",  image: "ic_sport_gps_map_mode", target: self, action: #selector(selectMapButtonClick(button:)))
        return btn
    }()
    
    //懒加载GPS按钮
    fileprivate lazy var GPSButton:CLGPSButton = {
        
        let btn = CLGPSButton(title: "  GPS信号好  ",  image: "ic_sport_gps_map_connect_3")
        btn.tag = 2
        return btn
    }()
    
    /// 转场效果设置
    override func loadView() {
        super.loadView()
        //取消系统自带转场
        self.modalPresentationStyle = .custom
        //创建动画模型
        presentAnmation = CLCustomPresentAnnimation(startRect: CGRect(x: view.bounds.size.width - 20, y: 20, width: 50, height: 50), animationTime: 0.5)
        //设置代理
        transitioningDelegate = presentAnmation
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("CLSportMapVC释放啦")
    }
    
}

extension CLSportMapVC {
    
    override func setupUI() {
        /// 添加地图
        addMapView()
        /// 添加底部毛玻璃视图
        addVisualView()
        /// 添加其余控件
        addButton()
    }
    
    /// 添加地图
    fileprivate func addMapView() {
        let mapView: MAMapView = MAMapView(frame: self.view.bounds)
        self.mapView = mapView
        mapView.delegate = self as MAMapViewDelegate
        mapView.isShowTraffic = true
        mapView.showsScale = false
        mapView.pausesLocationUpdatesAutomatically = false;
        mapView.allowsBackgroundLocationUpdates = true;
        mapView.userTrackingMode = .followWithHeading;
        mapView.isRotateEnabled = false;
        
        self.view.addSubview(mapView)
        
    }
    
    /// 添加底部毛玻璃视图
    fileprivate func addVisualView() {
        
        view.addSubview(visualEffetView)
        visualEffetView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(90)
        }
        visualEffetView.contentView.addSubview(kmLabel)
        visualEffetView.contentView.addSubview(timeLabel)
        visualEffetView.contentView.addSubview(distanceLabel)
        visualEffetView.contentView.addSubview(durationLabel)
        //设置约束
        kmLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(visualEffetView.contentView.snp.centerX).offset(-Screen_Width / 4)
            make.top.equalTo(visualEffetView.contentView).offset(margin)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(visualEffetView.contentView.snp.centerX).offset(Screen_Width / 4)
            make.top.equalTo(kmLabel.snp.top)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(kmLabel)
            make.top.equalTo(kmLabel.snp.bottom).offset(margin)
        }
        durationLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(timeLabel)
            make.top.equalTo(distanceLabel)
        }
        
    }
    
    /// 添加其余控件
    fileprivate func addButton() {
        view.addSubview(dismissButtonClick)
        view.addSubview(selectMapButton)
        view.addSubview(GPSButton)
        dismissButtonClick.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-margin)
            make.bottom.equalTo(visualEffetView.snp.top).offset(-margin)
        }
        selectMapButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(margin)
            make.bottom.equalTo(visualEffetView.snp.top).offset(-margin)
        }
        GPSButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(margin * 2)
        }
        
    }
}


// MARK: - 点击事件处理
extension CLSportMapVC {
    
    /// dismiss
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func dismissButtonClick(button:UIButton) {
        dismiss(animated: true, completion: nil);
    }
    
    /// 切换地图调用方法
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func selectMapButtonClick(button:UIButton) {
        
        let mapBoldVC = CLMapBoldVC()

        mapBoldVC.view.backgroundColor = UIColor.white
        mapBoldVC.modalPresentationStyle = .popover
 
        let presentVC: UIPopoverPresentationController = mapBoldVC.popoverPresentationController!
        presentVC.sourceView = self.selectMapButton

        presentVC.permittedArrowDirections = .down
        
        mapBoldVC.preferredContentSize = CGSize(width: 280, height: 100)

        presentVC.delegate = self

        present(mapBoldVC, animated: true, completion: nil)

        mapBoldVC.currentIndex = (self.mapView?.mapType).map { $0.rawValue }!
        
        mapBoldVC.complete = {
            (index : NSInteger) in            
            self.mapView?.mapType = MAMapType(rawValue: index - 1)!
        }
    }
    
}


// MARK: - UIPopoverPresentationControllerDelegate代理
extension CLSportMapVC:UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        //不进行自适应
        return UIModalPresentationStyle.none
    }
    
}


// MARK: - MAMapViewDelegate
extension CLSportMapVC: MAMapViewDelegate {
    
    /**
     * @brief 位置或者设备方向更新后，会调用此函数
     * @param mapView 地图View
     * @param userLocation 用户定位信息(包括位置与设备方向等数据)
     * @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
     */
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        
        //三次滤波算法
        if index2 < 3 {
            index2 += 1
            print(index2)
            return
        }
        
        guard updatingLocation == true else {
            return
        }
        
        if (self.startLocation == nil) {
            
            startLocation = userLocation.location
            
            let pointAnnotation = MAPointAnnotation()
            pointAnnotation.coordinate = userLocation.location.coordinate
            pointAnnotation.title = userLocation.title
            pointAnnotation.subtitle = userLocation.subtitle
            
            mapView.addAnnotation(pointAnnotation)
        }
        
        let arr:NSArray = [trackModel?.drawPolyLineWithLocation(location: (userLocation?.location)!) ?? (Any).self]
        
        mapView.addOverlays(arr as! [Any])
        //给显示数据赋值
        kmLabel.text = String(format: "%.2f", (trackModel?.totalDistance)!)
        timeLabel.text = trackModel?.totalTimeStr
        if (self.delegate != nil)  {
            self.delegate?.sportMapVC(mapVC: self, sportTrackingModel: trackModel!)
        }
        
    }
    
    /**
     * @brief 根据anntation生成对应的View
     * @param mapView 地图View
     * @param annotation 指定的标注
     * @return 生成的标注View
     */
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        print(annotation)
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            
            
            let image: UIImage = (trackModel?.sportImage())!
            
            annotationView?.image = image
            
            annotationView?.centerOffset = CGPoint(x: 0, y: -image.size.height / 2)
            
            return annotationView!
        }
        
        return nil
    }
    
    /**
     * @brief 根据overlay生成对应的Renderer
     * @param mapView 地图View
     * @param overlay 指定的overlay
     * @return 生成的覆盖物Renderer
     */
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5.0
            
            let polyLine = overlay as! CLSportPolyLine
            
            renderer.strokeColor = polyLine.color
            
            return renderer
        }
        return nil
    }
    
}

