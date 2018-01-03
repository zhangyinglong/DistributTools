//
//  BaseTableViewController.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/6/3.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

import UIKit
import RxSwift

class BaseTableViewController<T>: UITableViewController {

    let disposeBag = DisposeBag()
    
    private(set) var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configure(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: T) {}

}
