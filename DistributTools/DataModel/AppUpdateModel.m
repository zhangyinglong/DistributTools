//
//  AppUpdateModel.m
//  DistributTools
//
//  Created by zhangyinglong on 16/1/19.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

#import "AppUpdateModel.h"

@interface AppUpdateModel ()

@end

@implementation AppUpdateModel

- (void)setNeedUpdate:(BOOL)isNeedUpdate {
    _isNeedUpdate = isNeedUpdate;
}

- (BOOL)isEqualApp:(AppUpdateModel *)app {
    if ( app ) {
        return (self.appIdentifier == app.appIdentifier);
    } else {
        return NO;
    }
}

@end
