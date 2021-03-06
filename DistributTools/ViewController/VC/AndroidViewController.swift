//
//  AndroidViewController.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/8.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

import UIKit
import Material
import VCMaterialDesignIcons
import ICDMaterialActivityIndicatorView
import DZNEmptyDataSet
import YYWebImage

class AndroidViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    private var current_page: Int = 0

    private var dataSource: [AppInfo] = [AppInfo]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: self.view.width,
                                                  height: self.view.height - 70),
                                    style: UITableViewStyle.plain)
        tableView.register(AppItemTableViewCell.classForCoder(), forCellReuseIdentifier: "AppItemTableViewCell")
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.delegate = self;
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    private var failedLoading: Bool = false

    private lazy var activityView: ICDMaterialActivityIndicatorView = {
        return self.getActivityIndicatorView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = DGElasticPullToRefreshLoadingViewBall();
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.fetchAppList()
            self!.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        tableView.dg_setPullToRefreshFillColor(Color.lightBlue.lighten1)
        
        self.activityView.top -= 150
        self.fetchAppList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAppList() {
        self.activityView.startAnimating()
        PgyerAPI.request(.listMyPublished(params: ["page":current_page]), success: { [weak self] (list: AppInfoList) -> Void in
            self?.activityView.stopAnimating()
            self?.dataSource = list.list.filter({ return $0.appType == .android })
            self?.tableView.reloadData()
        }) { [weak self] error in
            log.verbose(error)
            
            self?.activityView.stopAnimating()
            self?.failedLoading = true
        }
    }
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppItemTableViewCell.getCellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AppItemTableViewCell", for: indexPath as IndexPath) as! AppItemTableViewCell
//        cell.appInfo = dataSource[indexPath.row]
        let line: UIView = UIView(frame: CGRect(x: 0, y: cell.contentView.height - 0.5, width: cell.contentView.width, height: 0.5))
        line.backgroundColor = UIColor(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)
        cell.contentView.addSubview(line)
        cell.setNeedsLayout()
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
//        let cell: AppItemTableViewCell = self.tableView(tableView, cellForRowAt: indexPath) as! AppItemTableViewCell
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        let appDetailViewController: AppDetailViewController = AppDetailViewController()
//        appDetailViewController.appItemModel = (self.dataSource.object(at: indexPath.row) as! AppItemModel)
//        appDetailViewController.appItemModel.image = cell.appIcon.image
//        appDelegate.getNavigationController().pushViewController(appDetailViewController, animated: true)
        
//        UserDefaults.standard.set(appDetailViewController.appItemModel!.appUpdateModel.appBuildVersion,
//                                  forKey: appDetailViewController.appItemModel!.appUpdateModel.appIdentifier)
    }
    
    // DZNEmptyDataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard !self.failedLoading else {
            return nil
        }
        
        return NSAttributedString(string: "网络不给力", attributes: [NSFontAttributeName : RobotoFont.light(with: 15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard !self.failedLoading else {
            return nil
        }
        
        return NSAttributedString(string: "检查网络，并尝试刷新", attributes: [NSFontAttributeName : RobotoFont.light(with: 15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        guard !self.failedLoading else {
            return nil
        }
        
        let m: VCMaterialDesignIcons = VCMaterialDesignIcons.icon(withCode: VCMaterialDesignIconCode.md_refresh.takeRetainedValue() as String, fontSize: 25)
        m.addAttribute(NSForegroundColorAttributeName, value: Color.blue.lighten1)
        return m.image()
    }
    
    // DZNEmptyDataSetDelegate
    
    private func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        self.failedLoading = false
        self.tableView.reloadEmptyDataSet()
        self.fetchAppList()
    }
    
}
