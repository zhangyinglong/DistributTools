//
//  HUD.swift
//  DistributTools
//
//  Created by zhang yinglong on 2018/1/3.
//  Copyright © 2018年 ChinaHR. All rights reserved.
//

import MBProgressHUD
import Dispatch

class HUD {
    
    class func flash(_ text: String, mode: MBProgressHUDMode = .text, toView: UIView? = UIApplication.shared.keyWindow, isbelow: Bool = false, delay: TimeInterval = 2.0, theHud: MBProgressHUD? = nil) {
        main_async {
            if let toView = toView {
                let hud = theHud ?? MBProgressHUD.showAdded(to: toView, animated: true)
                hud.mode = mode
                hud.label.text = text
                hud.label.numberOfLines = 0
                if isbelow {
                    hud.offset = CGPoint(x: 0, y: MBProgressMaxOffset)
                }
                hud.isUserInteractionEnabled = false
                hud.hide(animated: true, afterDelay: delay)
            }
        }
    }
    
    class func loading(_ task: @escaping ()->Void) {
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.isUserInteractionEnabled = false
        async {
            // 后台操作
            task()
            
            main_async {
                hud.hide(animated: true)
            }
        }
    }
    
    class func showLoading() -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.isUserInteractionEnabled = false
        return hud
    }
    
}
