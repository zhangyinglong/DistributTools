//
//  AppItemModel.h
//  PuhuiDownloader
//
//  Created by zhangyinglong on 16/1/9.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppUpdateModel.h"

@interface AppItemModel : NSObject

@property (nonatomic, strong) AppUpdateModel *appUpdateModel;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isNewVersion;

@end
