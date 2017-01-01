//
//  AndroidViewController.swift
//  PuhuiDownloader
//
//  Created by zhangyinglong on 16/1/8.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

import UIKit
import MK
import VCMaterialDesignIcons
import ICDMaterialActivityIndicatorView
import DZNEmptyDataSet

class AndroidViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    private var current_page: Int = 0

    private var dataSource: NSMutableArray =  NSMutableArray(capacity: 0)

    internal var tableView: UITableView!

    private var activityView: ICDMaterialActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRectMake(0, 0, self.view.width, self.view.height - 70), style: UITableViewStyle.Plain)
        tableView.registerClass(AppItemTableViewCell.classForCoder(), forCellReuseIdentifier: "AppItemTableViewCell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.showsVerticalScrollIndicator   = false;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self;
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.view.addSubview(tableView)

        let loadingView: DGElasticPullToRefreshLoadingViewBall = DGElasticPullToRefreshLoadingViewBall();
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.fetchAppList()
            self!.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        tableView.dg_setPullToRefreshFillColor(MaterialColor.lightBlue.lighten1)

        self.activityView = self.getActivityIndicatorView()
        self.activityView.top -= 150
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchAppList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //

    func fetchAppList() {
        if !self.activityView.animating {
            self.activityView.startAnimating()
            AppInformationService.defaultService().listMyPublished(PgyerModule.uKey, _api_key: PgyerModule.api_key, page: current_page,
                success: { [weak self] (array) -> Void in
                    let tmpDataSource: NSMutableArray = NSMutableArray(capacity: 0)
                    for item in array {
                        if item.appType == 2 {
                            let appItem: AppItemModel = AppItemModel()
                            appItem.appUpdateModel = item as! AppUpdateModel
                            tmpDataSource.addObject(appItem)
                        }
                    }
                    if tmpDataSource.count > 0 {
                        self!.dataSource = tmpDataSource
                        self!.tableView.reloadData()
                    }
                    self!.activityView.stopAnimating()
                }) { [weak self] (task, error) -> Void in
                    self!.activityView.stopAnimating()
            }
        }
    }

    // UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppItemTableViewCell.getCellHeight()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AppItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("AppItemTableViewCell", forIndexPath: indexPath) as! AppItemTableViewCell
        let appItemModel: AppItemModel = self.dataSource.objectAtIndex(indexPath.row) as! AppItemModel

        let url = PgyerModule.image_host + appItemModel.appUpdateModel.appIcon
        cell.appIcon.setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "logo"))
        cell.appName.text = appItemModel.appUpdateModel.appName + " V" + appItemModel.appUpdateModel.appVersion
        cell.appName.width = (cell.appName.text! as NSString).boundingRectWithSize(CGSizeMake(cell.appName.width, cell.appName.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: cell.appName.font], context: nil).width
        cell.appContent.text = appItemModel.appUpdateModel.appDescription.isEmpty ? "这家伙很懒，什么也没留下" : appItemModel.appUpdateModel.appDescription
        cell.appCreateTime.text = appItemModel.appUpdateModel.appCreated
        cell.badgeView.hidden = !appItemModel.isNewVersion
        cell.badgeView.dragdropCompletion = { () -> Void in
            NSUserDefaults.standardUserDefaults().setInteger(appItemModel.appUpdateModel.appBuildVersion,
                                                            forKey: appItemModel.appUpdateModel.appIdentifier)
        }

        let line: UIView = UIView(frame: CGRectMake(0, cell.contentView.height - 0.5, cell.contentView.width, 0.5))
        line.backgroundColor = UIColor(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)
        cell.contentView.addSubview(line)
        return cell
    }

    // UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDetailViewController: AppDetailViewController = AppDetailViewController()
        appDetailViewController.appItemModel = (self.dataSource.objectAtIndex(indexPath.row) as! AppItemModel)

        let cell:AppItemTableViewCell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath) as! AppItemTableViewCell
        appDetailViewController.appItemModel?.image = cell.appIcon.image
        appDelegate.getNavigationController().pushViewController(appDetailViewController, animated: true)

        NSUserDefaults.standardUserDefaults().setInteger(appDetailViewController.appItemModel!.appUpdateModel.appBuildVersion,
                                                        forKey: appDetailViewController.appItemModel!.appUpdateModel.appIdentifier)
    }

    // DZNEmptyDataSetSource

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "网络不给力", attributes: [NSFontAttributeName : RobotoFont.lightWithSize(15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "检查网络，并尝试刷新", attributes: [NSFontAttributeName : RobotoFont.lightWithSize(15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }

    func buttonImageForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        let m: VCMaterialDesignIcons = VCMaterialDesignIcons.iconWithCode(VCMaterialDesignIconCode.md_refresh.takeRetainedValue() as String, fontSize: 25)
        m.addAttribute(NSForegroundColorAttributeName, value: MaterialColor.blue.lighten1)
        return m.image()
    }

    // DZNEmptyDataSetDelegate

    func emptyDataSet(scrollView: UIScrollView!, didTapView view: UIView!) {
        self.fetchAppList()
    }

    func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        self.fetchAppList()
    }

}
