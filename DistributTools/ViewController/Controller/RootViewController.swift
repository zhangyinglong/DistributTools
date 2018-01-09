//
//  RootViewController.swift
//  DistributTools
//
//  Created by zhangyinglong on 2016/12/30.
//  Copyright © 2016年 zhang yinglong. All rights reserved.
//

import UIKit
import Material
import MarqueeLabel
import Cartography

class RootViewController: UIViewController, UIScrollViewDelegate {

    private lazy var navigationBarView: NavigationBar = {
       return self.getNavigationBarView()
    }()
    
    private var initialSelectedBackgroundViewFrame: CGRect!
    
    private var initialContentOffsetX: CGFloat = 0
    
    private var isDragging: Bool = false
    
    fileprivate lazy var vm: AppListViewModel = AppListViewModel()
    
    internal lazy var iosViewController: IOSViewController = {
        let vc = IOSViewController()
        vc.vm = self.vm
        return vc
    }()
    
//    internal lazy var iosViewController: RxTableViewController = RxTableViewController()
    
    internal lazy var androidViewController: AndroidViewController = {
        let vc = AndroidViewController()
        vc.vm = self.vm
        return vc
    }()
    
    private lazy var switchControl: DGRunkeeperSwitch = {
        var switchControl = DGRunkeeperSwitch(titles: ["iOS", "Android"])
        switchControl.backgroundColor = UIColor(red: 30/255.0, green: 132/255.0, blue: 194/255.0, alpha: 1.0)
        switchControl.selectedBackgroundColor = .white
        switchControl.titleColor = .white
        switchControl.selectedTitleColor = UIColor(red: 41/255.0, green: 182/255.0, blue: 246/255.0, alpha: 1.0)
        switchControl.titleFont = RobotoFont.regular(with: 17)
        switchControl.frame = CGRect(x: (self.view.width - 200)/2,
                                y: (self.navigationBarView.height - 35.0) / 2 + 10,
                                width: 200,
                                height: 35.0)
        switchControl.frame = CGRect(x: 50,
                                     y: (self.navigationBarView.height - 35.0) / 2 + 10,
                                     width: self.view.width - 100,
                                     height: 35.0)
        switchControl.autoresizingMask = [.flexibleWidth]
        return switchControl
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: self.navigationBarView.height, width: self.view.width, height: self.view.height - self.navigationBarView.height))
        scrollView.contentSize = CGSize(width: self.view.width * 2, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var infoBanner: MarqueeLabel = {
        let infoBanner: MarqueeLabel = MarqueeLabel(frame: CGRect(x: 0, y: self.navigationBarView.height, width: self.view.width, height: 28))
        infoBanner.marqueeType = MarqueeType.MLContinuous
//        infoBanner.scrollRate = 35
        infoBanner.textAlignment = .center
        infoBanner.textColor = Color.white
        infoBanner.backgroundColor = Color.lightBlue.lighten1
        infoBanner.font = RobotoFont.regular(with: 14)
        return infoBanner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.switchControl.setSelectedIndex(0, animated: true)
        self.switchControl.addTarget(self, action: #selector(onValueChaneged), for: .valueChanged)
        self.vm.refreshCommand.onNext(())
    }

    override func loadView() {
        super.loadView()
        
        self.navigationBarView.addSubview(self.switchControl)
        self.view.addSubview(self.scrollView)
        
        var frame: CGRect = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - self.navigationBarView.height)
        self.iosViewController.view.frame = frame
        frame = CGRect(x: self.view.width, y: 0, width: self.view.width, height: self.view.height - self.navigationBarView.height)
        self.androidViewController.view.frame = frame
        
        self.addChildViewController(self.iosViewController)
        self.scrollView.addSubview(self.iosViewController.view)
        
        self.addChildViewController(self.androidViewController)
        self.scrollView.addSubview(self.androidViewController.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let apps = AppUpdateModel.findByColumn("isNeedUpdate", value: true)
//        if (apps != nil && apps.count > 0) {
//            var info: String = ""
//            for item in apps {
//                info += item.appName + "、"
//            }
//            info += "有新版本更新，快去查看吧！"
//            self.infoBanner.text = info
//            view.addSubview(self.infoBanner)
//            self.iosViewController.view.top = self.infoBanner.height
//            self.iosViewController.view.height = (self.view.height - self.infoBanner.height)
//            self.iosViewController.tableView.height = (self.view.height - self.navigationBarView.height - self.infoBanner.height)
//            self.androidViewController.view.top = self.infoBanner.height
//            self.androidViewController.view.height = (self.view.height - self.infoBanner.height)
//            self.androidViewController.tableView.height = (self.view.height - self.navigationBarView.height - self.infoBanner.height)
//        } else {
//            self.infoBanner.removeFromSuperview()
//            self.iosViewController.view.top = 0
//            self.iosViewController.view.height = self.view.height
//            self.iosViewController.tableView.height = (self.view.height - self.navigationBarView.height)
//            self.androidViewController.view.top = 0
//            self.androidViewController.view.height = self.view.height
//            self.androidViewController.tableView.height = (self.view.height - self.navigationBarView.height)
//        }
    }

    // 
    func onValueChaneged() -> Void {
        if !self.isDragging {
            let x: CGFloat = CGFloat(self.switchControl.selectedIndex) * self.view.width
            let y: CGFloat = self.scrollView.contentOffset.y
            self.scrollView.setContentOffset(CGPoint(x: x, y: y), animated: true)
        }
    }
    
    // UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
        self.initialSelectedBackgroundViewFrame = self.switchControl.selectedBackgroundView.frame
        self.initialContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isDragging {
            var x: CGFloat = scrollView.contentOffset.x
            if self.initialContentOffsetX == scrollView.width {
                x = (x - self.initialContentOffsetX)
            }
            var frame = initialSelectedBackgroundViewFrame!
            frame.origin.x += ((x * self.switchControl.width) / self.scrollView.width)
            frame.origin.x = max(min(frame.origin.x, self.switchControl.bounds.width - 2.0 - frame.width), 2.0)
            self.switchControl.selectedBackgroundView.frame = frame
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.width)
        self.switchControl.setSelectedIndex(index, animated: true)
        
        self.isDragging = false
    }
    
}

