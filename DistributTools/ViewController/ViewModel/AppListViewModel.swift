//
//  AppListViewModel.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/6/3.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AppListViewModelProtocol {
    var rx_apps: Observable<[AppInfo]> { get }
}

final class AppListViewModel: AppListViewModelProtocol {

    var current_page = 0
    
    lazy var rx_apps: Observable<[AppInfo]> = {
        return self.loadData()
    }()
    
}

extension AppListViewModel {
    
    public func loadData() -> Observable<[AppInfo]> {
        return PgyerAPI.rx_requestArray(.listMyPublished(params: ["page":current_page]))
    }
    
}
