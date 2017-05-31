////
////  AppDetailViewController.swift
////  DistributTools
////
////  Created by zhangyinglong on 16/1/9.
////  Copyright © 2016年 ChinaHR. All rights reserved.
////
//
//import UIKit
//import WebKit
//import Dispatch
//import Material
//import VCMaterialDesignIcons
//import ICDMaterialActivityIndicatorView
//import DZNEmptyDataSet
//import SGActionView
//import SafariServices
//
//class AppDetailViewController: SFSafariViewController {
//
//    internal var appInfo: AppInfo = AppInfo() {
//        didSet {
//            let item = self.navigationBarView.topItem!
//            item.title = appInfo.appName
//        }
//    }
//    
//    internal var appShortcutUrl: String = "" {
//        didSet {
//            guard !appShortcutUrl.isEmpty else { return }
//            
//        }
//    }
//
//    private var appShortcutUrl: String!
//
//    private var failedLoading: Bool = false
//
//    private lazy var activityView: ICDMaterialActivityIndicatorView = {
//        return self.getActivityIndicatorView()
//    }()
//
//    private lazy var navigationBarView: NavigationBar = {
//        return self.getNavigationBarView()
//    }()
//
//    deinit {
//        print("AppDetailViewController dealloc")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        fetchAppDetail()
//    }
//
//    func socailShare() {
//        if self.activityView.isAnimating {
//            return
//        }
//        
////        SGActionView.showGridMenu(withTitle: nil,
////            itemTitles: ["微信好友", "朋友圈", "QQ", "QQ空间"],
////            images: [ UIImage(named: "social_WeChat")!,
////                      UIImage(named: "social_friend")!,
////                      UIImage(named: "social_qq")!,
////                      UIImage(named: "social_Qzone")! ]
////            ) { [weak self] index in
////                if index == 0 {
////
////                } else {
////                    let title: String = self?.appInfo.appName
////                    let description: String = self?.appInfo.appDescription
////                    let image: UIImage = self!.appItemModel.image!
////                    let url: String = self!.appShortcutUrl
////                    if (title.characters.count > 0
////                        && description.characters.count > 0
////                        && url.characters.count > 0) {
////                        ShareServiece.shareContent([ "title":title,
////                                                    "description":description,
////                                                    "image":image,
////                                                    "contentType":1,
////                                                    "url":url ],
////                            shareType: ShareType(rawValue: index)!,
////                            complete: { (success, error) -> Void in
////                                ShareServiece.reset()
////                                var message: String = "成功"
////                                if !success {
////                                    message = error!
////                                }
////                                self?.showAlertView(title: "提示", message: message)
////                        })
////                    } else {
////                        self?.showAlertView(title: "提示", message: "分享失败请重新尝试")
////                    }
////                }
////        }
//    }
//    
//    func fetchAppDetail() {
//        self.activityView.startAnimating()
//        PgyerAPI.request(.view(params: [ "aKey":appInfo.appKey]), success: { [weak self] (info: AppInfo) -> Void in
//            log.debug("info = \(info)")
//        }) { [weak self] error in
//            log.verbose(error)
//            
//            self?.activityView.stopAnimating()
//        }
//        
//        
////        AppInformationService.defaultService().viewAppInformation(aKey: (self.appItemModel?.appUpdateModel?.appKey)!,
////            uKey: PgyerModule.uKey, _api_key: PgyerModule.api_key, success: { [weak self] (task, response) -> Void in
////            if let responseDic: NSDictionary = response as? NSDictionary {
////                let data: NSDictionary = responseDic["data"] as! NSDictionary
////                self!.appShortcutUrl = (PgyerModule.host + "/" + (data.object(forKey: "appShortcutUrl") as! String))
////                _ = self?.webView.load(URLRequest(url: URL(string: (self?.appShortcutUrl)!)!))
////            } else {
////                self?.loadErrorHtml()
////            }
////        }, failure: { [weak self] (task, error) -> Void in
////            self?.loadErrorHtml()
////        })
//    }
//
//}
