//
//  UIView-Extension.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK:- 得到当前正在显示的控制器
    class func currentViewController() -> UIViewController {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        return UIView.findBestViewController(vc: vc!)
    }
    
    private class func findBestViewController(vc : UIViewController) -> UIViewController {
        
        if vc.presentedViewController != nil {
            return UIView.findBestViewController(vc: vc.presentedViewController!)
        } else if vc.isKind(of:UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return UIView.findBestViewController(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let nvc = vc as! UINavigationController
            if nvc.viewControllers.count > 0 {
                return UIView.findBestViewController(vc: nvc.topViewController!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UITabBarController.self) {
            let tvc = vc as! UITabBarController
            if (tvc.viewControllers?.count)! > 0 {
                return UIView.findBestViewController(vc: tvc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
    }
    
//    // MARK:- 查找正在显示的控制器
//    func findController() -> UIViewController! {
//        return self.findControllerWithClass(UIViewController.self)
//    }
//
//    func findNavigator() -> UINavigationController! {
//        return self.findControllerWithClass(UINavigationController.self)
//    }
//
//    func findControllerWithClass<T>(_ clzz: AnyClass) -> T? {
//        var responder = self.next
//        while(responder != nil) {
//            if (responder!.isKind(of: clzz)) {
//                return responder as? T
//            }
//            responder = responder?.next
//        }
//
//        return nil
//    }
    
}
