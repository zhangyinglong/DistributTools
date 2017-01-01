//
//  AppDetailViewController.swift
//  PuhuiDownloader
//
//  Created by zhangyinglong on 16/1/9.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

import UIKit
import WebKit
import Dispatch
import Material
import VCMaterialDesignIcons
import ICDMaterialActivityIndicatorView
import DZNEmptyDataSet
import SGActionView

class AppDetailViewController: UIViewController,
                                WKNavigationDelegate,
                                WKUIDelegate,
                                DZNEmptyDataSetSource,
                                DZNEmptyDataSetDelegate {

    internal var appItemModel: AppItemModel!

    private var appShortcutUrl: String!

    private var webView: WKWebView!

    private var failedLoading: Bool = false

    private var activityView: ICDMaterialActivityIndicatorView!

    private var navigationBarView: NavigationBar!

    deinit {
        print("AppDetailViewController dealloc")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appItemModel!.appUpdateModel.setNeedUpdate(false)
        self.appItemModel!.appUpdateModel.save()

        self.navigationBarView = self.getNavigationBarView()
        let item: UINavigationItem = self.navigationBarView.topItem!
        item.title = self.appItemModel!.appUpdateModel.appName
        
        let left_code: String = VCMaterialDesignIconCode.md_long_arrow_left.takeRetainedValue() as String
        let left_image: UIImage = self.getMaterialDesignIcon(code: left_code, fontSize: 25)
        let left_btn: FlatButton = self.getBtnWithImage(image: left_image, action: #selector(back))
        item.navigationItem.leftViews = [ left_btn ]

        let right_code: String = VCMaterialDesignIconCode.md_share.takeRetainedValue() as String
        let right_image: UIImage = self.getMaterialDesignIcon(code: right_code, fontSize: 25)
        let right_btn: FlatButton = self.getBtnWithImage(image: right_image, action: #selector(socailShare))
        item.navigationItem.rightViews = [ right_btn ]

        self.webView = WKWebView(frame: CGRect(x: 0, y: navigationBarView.height,
                                               width: view.width,
                                               height: view.height - navigationBarView.height))
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.scrollView.emptyDataSetSource = self
        self.webView.scrollView.emptyDataSetDelegate = self
        self.view.addSubview(self.webView)

        self.activityView = self.getActivityIndicatorView()

        // 布局
        Layout.top(parent: view, child: self.webView, top: 64)
        Layout.height(parent: view, child: self.webView, height: self.view.height - 64)
        Layout.width(parent: view, child: self.webView, width: self.view.width)

        self.fetchAppDetail()
    }

    override func back() {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        } else {
            super.back()
        }
    }

    func socailShare() {
        if self.activityView.isAnimating {
            return
        }
        
        SGActionView.showGridMenu(withTitle: nil,
            itemTitles: ["微信好友", "朋友圈", "QQ", "QQ空间"],
            images: [ UIImage(named: "social_WeChat")!,
                      UIImage(named: "social_friend")!,
                      UIImage(named: "social_qq")!,
                      UIImage(named: "social_Qzone")! ]
            ) { [weak self] (index) -> Void in
                if index == 0 {

                } else {
                    let title: String = self!.appItemModel.appUpdateModel.appName
                    let description: String = self!.appItemModel.appUpdateModel.appDescription
                    let image: UIImage = self!.appItemModel.image
                    let url: String = self!.appShortcutUrl
                    if (title.characters.count > 0
                        && description.characters.count > 0
                        && url.characters.count > 0) {
                        ShareServiece.shareContent([ "title":title,
                                                    "description":description,
                                                    "image":image,
                                                    "contentType":1,
                                                    "url":url ],
                            shareType: ShareType(rawValue: index)!,
                            complete: { (success, error) -> Void in
                                ShareServiece.reset()
                                var message: String = "成功"
                                if !success {
                                    message = error!
                                }
                                self?.showAlertView(title: "提示", message: message)
                        })
                    } else {
                        self?.showAlertView(title: "提示", message: "分享失败请重新尝试")
                    }
                }
        }
    }

    func loadErrorHtml() -> Void {
        self.failedLoading = true
       self.webView.scrollView.reloadEmptyDataSet();
    }
    
    func fetchAppDetail() {
        self.failedLoading = false
        self.webView.scrollView.setNeedsDisplay()
        activityView.startAnimating()
        AppInformationService.defaultService().viewAppInformation(aKey: (self.appItemModel?.appUpdateModel.appKey)!,
            uKey: PgyerModule.uKey, _api_key: PgyerModule.api_key, success: { [weak self] (task, response) -> Void in
            if let responseDic: NSDictionary = response as? NSDictionary {
                let data: NSDictionary = responseDic["data"] as! NSDictionary
                self!.appShortcutUrl = (PgyerModule.host + "/" + (data.object(forKey: "appShortcutUrl") as! String))
                _ = self?.webView.load(URLRequest(url: URL(string: (self?.appShortcutUrl)!)!))
            } else {
                self?.loadErrorHtml()
            }
        }, failure: { [weak self] (task, error) -> Void in
            self?.loadErrorHtml()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    // WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /*! @abstract Decides whether to allow or cancel a navigation after its
     response is known.
     @param webView The web view invoking the delegate method.
     @param navigationResponse Descriptive information about the navigation
     response.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
     @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /*! @abstract Invoked when a main frame navigation starts.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    /*! @abstract Invoked when a server redirect is received for the main
     frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    /*! @abstract Invoked when an error occurs while starting to load data for
     the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     */
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
    
    /*! @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    /*! @abstract Invoked when a main frame navigation completes.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
        
        let str: String = "document.getElementsByClassName('copyright')[0].remove();"
        webView.evaluateJavaScript(str)
    }
    
    /*! @abstract Invoked when an error occurs during a committed main frame
     navigation.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
        self.loadErrorHtml()
    }
    
    // DZNEmptyDataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if (self.webView.isLoading || !self.failedLoading) {
            return nil;
        }
        
        return NSAttributedString(string: "网络不给力", attributes: [NSFontAttributeName : RobotoFont.light(with: 15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if (self.webView.isLoading || !self.failedLoading) {
            return nil;
        }
        
        return NSAttributedString(string: "检查网络，并尝试刷新", attributes: [NSFontAttributeName : RobotoFont.light(with: 15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        if (self.webView.isLoading || !self.failedLoading) {
            return nil;
        }
        
        let m: VCMaterialDesignIcons = VCMaterialDesignIcons.icon(withCode: VCMaterialDesignIconCode.md_refresh.takeRetainedValue() as String, fontSize: 25)
        m.addAttribute(NSForegroundColorAttributeName, value: Color.blue.lighten1)
        return m.image()
    }
    
    // DZNEmptyDataSetDelegate
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.failedLoading = false
        self.webView.scrollView.reloadEmptyDataSet();
        self.fetchAppDetail()
    }

}
