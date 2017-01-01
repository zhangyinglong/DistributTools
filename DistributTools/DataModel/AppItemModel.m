//
//  AppItemModel.m
//  DistributTools
//
//  Created by zhangyinglong on 16/1/9.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

#import "AppItemModel.h"

@implementation AppItemModel

- (BOOL)isNewVersion {
    id old = [[NSUserDefaults standardUserDefaults] objectForKey:self.appUpdateModel.appIdentifier];
    if ( old == nil ) {
        return YES;
    } else if ( self.appUpdateModel.appBuildVersion > [old integerValue] ) {
        return YES;
    }
    return NO;
}

@end
