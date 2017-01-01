//
//  AppUpdateModel.h
//  DistributTools
//
//  Created by zhangyinglong on 16/1/19.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

#import "BaseModel.h"

@interface AppUpdateModel : BaseModel

@property (nonatomic, copy) NSString *appIdentifier;
@property (nonatomic, assign) NSInteger appBuildVersion;
@property (nonatomic, copy) NSString *appCreated;
@property (nonatomic, copy) NSString *appDescription;
@property (nonatomic, assign) UInt64 appFileSize;
@property (nonatomic, copy) NSString *appIcon;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appScreenshots;
@property (nonatomic, assign) NSInteger appType;
@property (nonatomic, copy) NSString *appUpdateDescription;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appVersionNo;
@property (nonatomic, assign) BOOL isNeedUpdate;

- (void)setNeedUpdate:(BOOL)isNeedUpdate;

- (BOOL)isEqualApp:(AppUpdateModel *)app;

@end
