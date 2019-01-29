//
//  PhotoBrowerData.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit

public class PhotoBrowerData: NSObject {
    
    // 网络图片地址
    public var url: String? {
        didSet {
            sourceType = .netImage
        }
    }
    
    // 本地图片
    public var image: UIImage? {
        didSet {
            sourceType = .localImage
        }
    }
    
    // 原始点击图像
    public var sourceObject: UIImageView?
    
    // 资源类型：本地图片，网络图片
    public var sourceType: PhotoBrowerDataSourceType?
    
    // MARK:- 初始化网络图片
    init(url: String, sourceObject: UIImageView) {
        self.url = url
        self.sourceObject = sourceObject
        self.sourceType = .netImage
    }
    
    // MARK:- 初始化本地图片
    init(image: UIImage, sourceObject: UIImageView) {
        self.image = image
        self.sourceObject = sourceObject
        self.sourceType = .localImage
    }
    
    public override init() {
        super.init()
    }
}
