//
//  UINavigationBarExt.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/7/26.
//  Copyright © 2017年 sip. All rights reserved.
//

import Material

extension UINavigationBar {
    private struct AssociatedKeys {
        static var overlayKey = "overlayKey"
    }
    
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue as UIView?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}


extension UINavigationBar {
    
    func lt_setBackgroundColor(backgroundColor: UIColor) {
        if overlay == nil {
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
            overlay = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: self.height))
            overlay?.isUserInteractionEnabled = false
            overlay?.autoresizingMask = UIViewAutoresizing.flexibleWidth
            subviews.first?.insertSubview(overlay!, at: 0)
        }
        overlay?.backgroundColor = backgroundColor
    }
    
    
    func lt_setTranslationY(translationY: CGFloat) {
        transform = CGAffineTransform.init(translationX: 0, y: translationY)
    }
    
    
    func lt_setElementsAlpha(alpha: CGFloat) {
        for (_, element) in subviews.enumerated() {
            if element.isKind(of: NSClassFromString("UINavigationItemView") as! UIView.Type) ||
                element.isKind(of: NSClassFromString("UINavigationButton") as! UIButton.Type) ||
                element.isKind(of: NSClassFromString("UINavBarPrompt") as! UIView.Type)
            {
                element.alpha = alpha
            }
            
            if element.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView") as! UIView.Type) {
                element.alpha = element.alpha == 0 ? 0 : alpha
            }
        }
        
        items?.forEach({ (item) in
            if let titleView = item.titleView {
                titleView.alpha = alpha
            }
            for BBItems in [item.leftBarButtonItems, item.rightBarButtonItems] {
                BBItems?.forEach({ (barButtonItem) in
                    if let customView = barButtonItem.customView {
                        customView.alpha = alpha
                    }
                })
            }
        })
    }
    
    
    func lt_reset() {
        setBackgroundImage(nil, for: .default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
}

class CustomNavigationBar: NavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            self.subviews.forEach({
                if "\(type(of: $0))" == "_UINavigationBarContentView"
                    || "\(type(of: $0))" == "_UIBarBackground"
                {
                    $0.frame = CGRect(x: $0.left, y: 0, width: $0.width, height: self.height)
                } else {
                    $0.frame = CGRect(x: $0.left, y: $0.top, width: $0.width, height: $0.height)
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
}
