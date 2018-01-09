//
//  AppListViewModel.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/6/3.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

import RxSwift
import NSObject_Rx

final class AppListViewModel: HasDisposeBag {

    let refreshCommand = PublishSubject<Void>()
    let loadCommand = PublishSubject<Void>()
    let apps = Variable([AppInfo]())
    
    var current_page = 0
    
    init() {
        refreshCommand.flatMapLatest { _ in AppListViewModel.loadApps(0) }
            .subscribe(onNext: { [weak self] value in
                self?.apps.value = value
            }, onError: { error in
                print("error = \(error.localizedDescription)")
            }).disposed(by: disposeBag)
        
//        loadCommand
    }
    
}

extension AppListViewModel {
    
    static func loadApps(_ page: Int) -> Observable<[AppInfo]> {
        return Observable.create({ (observer) -> Disposable in
            let target = PgyerAPI.listMyPublished(params: ["page": page])
            HttpClient<PgyerAPI, AppInfo>.requestArray(target) { result in
                switch result {
                case .success(let object):
                    observer.onNext(object)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        })
    }
    
}
