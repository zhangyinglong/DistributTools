//
//  UIViewController+Base.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/9.
//  Copyright © 2016年 zhang yinglong. All rights reserved.
//

import UIKit
import Material
import ICDMaterialActivityIndicatorView
import MarqueeLabel
import SafariServices

public extension UIViewController {

    /**
     构造公共导航栏
     */
    public func getNavigationBarView() -> NavigationBar {        
        if ((self.navigationController?.navigationBar) != nil) {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        let navigationBarView: NavigationBar = NavigationBar(frame: CGRect(x: 0, y: 0, width: view.width, height: 70))

        navigationBarView.translatesAutoresizingMaskIntoConstraints = false

        // Stylize.
        navigationBarView.backgroundColor = Color.lightBlue.lighten1

        // To lighten the status bar add the "View controller-based status bar appearance = NO"
        // to your info.plist file and set the following property.
        navigationBarView.barStyle = .default

        // Title label.
        let item = UINavigationItem(title: "")
//        item.navigationItem.titleLabel.textColor = Color.white
//        item.navigationItem.titleLabel.font = RobotoFont.regular(with: 20)
        navigationBarView.pushItem(item, animated: true);
        
        view.addSubview(navigationBarView)

        // 布局
        Layout.top(parent: view, child: navigationBarView)
        Layout.horizontally(parent: view, child: navigationBarView)
        Layout.height(parent: view, child: navigationBarView, height: 70)

        return navigationBarView
    }

    /**
     构造公共导航栏 左边按钮 - 文字
     */
    public func getBtnWithTitle(title: String, action: Selector) -> FlatButton {
        let btn: FlatButton = FlatButton(type: .custom)
        btn.pulseColor = Color.white
        btn.setTitle(title, for: .normal)
        btn.setTitle(title, for: .highlighted)
        btn.setTitleColor(Color.white, for: .normal)
        btn.setTitleColor(Color.white, for: .highlighted)
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }

    /**
     构造公共导航栏 左边按钮 - 图片
     */
    public func getBtnWithImage(image: UIImage, action: Selector) -> FlatButton {
        let btn: FlatButton = FlatButton(type: .custom)
        btn.pulseColor = Color.white
        btn.setImage(image, for: .normal)
        btn.setImage(image, for: .highlighted)
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }

    public func showAlertView(title: String?, message: String?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel: UIAlertAction = UIAlertAction(title: "知道了", style: .cancel) { [weak alert] _ in
            alert?.dismiss(animated: true)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    public func rootNavigationController() -> UINavigationController {
        return (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! UINavigationController
    }
    
    public func back() {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension UIViewController: SFSafariViewControllerDelegate {
    
    func openSafari(url: URL) {
        let webVC = SFSafariViewController(url: url)
        webVC.delegate = self
        self.present(webVC, animated: true, completion: nil)
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
