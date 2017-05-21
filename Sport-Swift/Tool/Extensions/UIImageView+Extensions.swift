//
//  UIImageView+Extensions.swift
//  WeiBo
//
//  Created by 夜猫子 on 2017/4/2.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    /// 图片名字
    /// 快速通过图片名字生成图片
    /// - Parameter imageName: 图片
    convenience init(imageName: String) {
        self.init()
        let image = UIImage(named: imageName)
        self.image = image
        
    }
    
    /// 封装SDWebImageView图片中间层,有占位图片
    ///
    /// - Parameters:
    ///   - urlStr: 图片url字符串
    ///   - placeHoder: 占位图的名字
    func cl_setImage(urlStr: String, placeHoder: String) {
        
        let url = URL(string: urlStr)
        let pImage = UIImage(named: placeHoder)
        if let url = url, let pImage = pImage {
            self.sd_setImage(with: url, placeholderImage: pImage)
        }
        
    }
    
    /// 封装SDWebImageView图片中间层，不需要占位图片
    ///
    /// - Parameters:
    ///   - urlStr: 图片url字符串
    ///   - placeHoder: 占位图的名字
    func cl_setImage(urlStr: String) {
        let url = URL(string: urlStr)
        if let url = url {
            self.sd_setImage(with: url)
        }
    }
    
    
}
