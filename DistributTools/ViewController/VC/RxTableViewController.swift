//
//  RxTableViewController.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/6/3.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import UIKit
import Material
import VCMaterialDesignIcons
import ICDMaterialActivityIndicatorView
import DZNEmptyDataSet
import SafariServices
import RxSwift
import RxCocoa

private let disposeBag = DisposeBag()

class RxTableViewController: UITableViewController {

    fileprivate var current_page: Int = 0
    
    fileprivate var failedLoading: Bool = false
    
    fileprivate var viewModel = AppListViewModel()
    
    fileprivate lazy var activityView: ICDMaterialActivityIndicatorView = {
        return self.getActivityIndicatorView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(AppItemTableViewCell.self, forCellReuseIdentifier: "AppItemTableViewCell")
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.rowHeight =  AppItemTableViewCell.CellHeight
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let loadingView = DGElasticPullToRefreshLoadingViewBall();
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.fetchAppList()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        tableView.dg_setPullToRefreshFillColor(Color.lightBlue.lighten1)
        
        activityView.top -= 150
        fetchAppList()

        viewModel.rx_apps.subscribe(onNext: { items in
            print("items")
            print(items)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
//        viewModel.loadData().bind(to: tableView.rx.items(cellIdentifier: "AppItemTableViewCell")) { index, model, cell in
//            (cell as! AppItemTableViewCell).appInfo = model
//            let line: UIView = UIView(frame: CGRect(x: 0, y: cell.contentView.height - 0.5, width: cell.contentView.width, height: 0.5))
//            line.backgroundColor = UIColor(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)
//            cell.contentView.addSubview(line)
//            cell.setNeedsLayout()
//        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RxTableViewController {
    
    fileprivate func fetchAppList() {
//        self.activityView.startAnimating()
//        PgyerAPI.rx_request(.listMyPublished(params: ["page":current_page]), success: { [weak self] (list: AppInfoList) -> Void in
//            self?.activityView.stopAnimating()
//
////            Observable.of(list.list.filter({ return $0.appType == .ios })).bind(to: (self?.tableView.rx.items(cellIdentifier: "AppItemTableViewCell"))!) { index, model, cell in
////                (cell as! AppItemTableViewCell).appInfo = model
////
////                let line: UIView = UIView(frame: CGRect(x: 0, y: cell.contentView.height - 0.5, width: cell.contentView.width, height: 0.5))
////                line.backgroundColor = UIColor(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)
////                cell.contentView.addSubview(line)
////                cell.setNeedsLayout()
////                }.addDisposableTo(disposeBag)
//        }) { [weak self] error in
//            log.verbose(error)
//            
//            self?.activityView.stopAnimating()
//            self?.failedLoading = true
//        }
    }
    
}

extension RxTableViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard !self.failedLoading else { return nil }
        
        return NSAttributedString(string: "网络不给力", attributes: [NSFontAttributeName : RobotoFont.light(with: 15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard !self.failedLoading else { return nil }
        
        return NSAttributedString(string: "检查网络，并尝试刷新", attributes: [NSFontAttributeName : RobotoFont.light(with: 15), NSForegroundColorAttributeName: UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)])
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        guard !self.failedLoading else { return nil }
        
        let m: VCMaterialDesignIcons = VCMaterialDesignIcons.icon(withCode: VCMaterialDesignIconCode.md_refresh.takeRetainedValue() as String, fontSize: 25)
        m.addAttribute(NSForegroundColorAttributeName, value: Color.blue.lighten1)
        return m.image()
    }
    
}

extension RxTableViewController: DZNEmptyDataSetDelegate {
    
    private func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        self.failedLoading = false
        self.tableView.reloadEmptyDataSet()
        self.fetchAppList()
    }
    
}
