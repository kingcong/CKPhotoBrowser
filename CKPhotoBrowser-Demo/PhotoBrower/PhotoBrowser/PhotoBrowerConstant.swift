//
//  PhotoBrowerConstant.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit

let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SAVE_SUCCESS = "保存成功"

public enum PhotoBrowerDataSourceType {
    case localImage     // 本地图片
    case netImage       // 网络图片
    case localVideo     // 本地视频
    case netVideo       // 网络视频
}
