//
//  UIButton-Extension.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init (imageName : String, bgImageName : String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor : UIColor, fontSize : CGFloat, title : String) {
        self.init()
        
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
