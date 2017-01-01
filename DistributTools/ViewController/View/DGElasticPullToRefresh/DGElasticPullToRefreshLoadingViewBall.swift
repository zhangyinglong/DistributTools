//
//  DGElasticPullToRefreshLoadingViewBall.swift
//  loanCustomer
//
//  Created by zhangyinglong on 16/1/1.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

// MARK: -
// MARK: DGElasticPullToRefreshLoadingViewBall

public class DGElasticPullToRefreshLoadingViewBall: DGElasticPullToRefreshLoadingView {

    // MARK: -
    // MARK: Vars
    
    private lazy var ballView : BallView = {
        var ballView = BallView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30),
                                circleSize: 28,
                                timingFunc: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                                moveUpDuration: 0.3,
                                moveUpDist: 0,
                                color: UIColor.white)
        return ballView
    }()

    override public init() {
        super.init(frame: .zero)

        self.addSubview(ballView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func startAnimating() {
        super.startAnimating()

        ballView.startAnimation()
    }

    override public func stopLoading() {
        super.stopLoading()

        ballView.endAnimation()
    }

    // MARK: -
    // MARK: Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        ballView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
    }
}
