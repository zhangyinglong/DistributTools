//
//  AppItemTableViewCell.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/8.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

import UIKit
import Material

let left_offset: CGFloat = 12

let iconSize: CGFloat = 76

let textDefaultColor: UIColor = UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)

class AppItemTableViewCell: UITableViewCell {

    internal var appInfo: AppInfo? {
        didSet {
            guard let info = appInfo else { return }
            
            let url = PgyerModule.image_host + info.appIcon
            appIcon.yy_setImage(with: URL(string: url)!, placeholder: UIImage(named: "logo"))
            appName.text = info.appName + " V" + info.appVersion
            appCreateTime.text = info.appCreated
            appContent.text = info.appDescription.isEmpty ? "这家伙很懒，什么也没留下" : info.appDescription
//            badgeView.isHidden = !appItemModel.isNewVersion
//            badgeView.dragdropCompletion = { () -> Void in
//                UserDefaults.standard.set(appItemModel.appUpdateModel!.appBuildVersion, forKey: (appItemModel.appUpdateModel?.id)!)
//            }

        }
    }

    internal lazy var appIcon: UIImageView = {
        var appIcon: UIImageView = UIImageView(frame: CGRect(x: left_offset, y: left_offset, width: iconSize, height: iconSize))
        return appIcon
    }()

    internal lazy var appName: UILabel = { 
        var appName: UILabel = UILabel(frame: CGRect(x: iconSize + 2 * left_offset, y: left_offset, width: UIScreen.main.bounds.width - iconSize - 3 * left_offset, height: 20))
        appName.font = RobotoFont.light(with: 16)
        appName.textColor = textDefaultColor
        return appName
    }()

    internal lazy var appCreateTime: UILabel = {
        var appCreateTime: UILabel = UILabel(frame: CGRect(x: iconSize + 2 * left_offset, y: left_offset + 20 + 5, width: UIScreen.main.bounds.width - iconSize - 3 * left_offset, height: 15))
        appCreateTime.font = RobotoFont.light(with: 13)
        appCreateTime.textColor = UIColor(red: 144/255.0, green: 144/255.0, blue: 144/255.0, alpha: 1.0)
        return appCreateTime
    }()

    internal lazy var appContent: UILabel = {
        var appContent: UILabel = UILabel(frame: CGRect(x: iconSize + 2 * left_offset,
                                                        y: left_offset + 2 * 20 + 3,
                                                        width: UIScreen.main.bounds.width - iconSize - 3 * left_offset,
                                                        height: AppItemTableViewCell.getCellHeight() - 2 * left_offset - 2 * 20))
        appContent.font = RobotoFont.light(with: 13)
        appContent.textColor = textDefaultColor
        appContent.numberOfLines = 0
        return appContent
    }()

    internal lazy var badgeView: PPDragDropBadgeView = {
        return PPDragDropBadgeView(frame: CGRect(x: UIScreen.main.bounds.width - left_offset - 50 + (50 - 10) / 2,
                                                 y: self.appCreateTime.top + (self.appCreateTime.height - 10)/2,
                                                 width: 10,
                                                 height: 10))
    }()

    private var appEnterPriseVersion: Bool {
        return false
//        get {
//            if let appInfo = self.appInfo {
//                return (appInfo.appUpdateModel?.id.contains(AppIdentifierModule.enterprise_appIdentifier))!
//            } else {
//                return false
//            }
//        }
    }

    private lazy var appType: UILabel = {
        let appType: UILabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - left_offset - 32,
                                                     y: left_offset + (20 - 13)/2,
                                                     width: 32,
                                                     height: 13))
        appType.font = RobotoFont.light(with: 9)
        appType.textAlignment = .center
        appType.textColor = Color.white
        appType.backgroundColor = Color.blue.lighten1
        appType.layer.cornerRadius = 2.0
        appType.layer.masksToBounds = true
        return appType
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.stepUpViews()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.stepUpViews()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

//    override func preparePulseView() {
//        pulseView.pulseColor = Color.lightBlue.lighten1.colorWithAlphaComponent(0.2)
//        contentView.addSubview(pulseView)
//    }

    func stepUpViews() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.appName)
        self.contentView.addSubview(self.appIcon)
        self.contentView.addSubview(self.appType)
        self.contentView.addSubview(self.appCreateTime)
        self.contentView.addSubview(self.appContent)
        self.contentView.addSubview(self.badgeView)

        // 布局
        Layout.topLeft(parent: self.contentView, child: self.appIcon, top: 10, left: 10)
        Layout.width(parent: self.contentView, child: self.appIcon, width: 70)
        Layout.height(parent: self.contentView, child: self.appIcon, height: 70)
    }

    static func getCellHeight() -> CGFloat {
        return 100.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if appEnterPriseVersion {
            appType.text = "企业版"
        } else {
            appType.text = "内测版"
        }
        if appName.text != nil {
            let text = appName.text! as NSString
            appName.width = text.boundingRect(with: CGSize(width: contentView.width, height: appName.height),
                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                              attributes: [NSFontAttributeName: appName.font],
                                              context: nil).width
            appType.left = (appName.right + 6)
        }

    }

}
