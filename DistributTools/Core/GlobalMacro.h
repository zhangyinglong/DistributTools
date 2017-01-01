//
//  GlobalMacro.h
//  DistributTools
//
//  Created by zhangyinglong on 16/1/9.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

#ifndef GlobalMacro_h
#define GlobalMacro_h

#define APP_SERVER_VERSION          @"3.0.0"
#define APP_VERSION                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define APP_DISPLAYNAME             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_BUNDEL_ID               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define APP_BUNDEL_NAME             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

#define IOS_VERSION                 [[[UIDevice currentDevice] systemVersion] floatValue]
#define ScreenHeight                ([[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth                 ([[UIScreen mainScreen] bounds].size.width)
#define SINGLE_LINE_WIDTH           (1.0f / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1.0f / [UIScreen mainScreen].scale) / 2)

#define kNullStr @""

#define GET_APP_DELEGATE                    (AppDelegate *)([UIApplication sharedApplication].delegate)
#define ROOT_NAVIGATECONTROLLER             [GET_APP_DELEGATE window].rootViewController
#define ROOT_NAVIGATECONTROLLER_PUSH(vc)    [(UINavigationController *)ROOT_NAVIGATECONTROLLER pushViewController: (vc)animated: YES]
#define ROOT_NAVIGATECONTROLLER_POPTO(vc)   [(UINavigationController *)ROOT_NAVIGATECONTROLLER popToViewController: (vc)animated: YES]
#define ROOT_NAVIGATECONTROLLER_POPTOROOT   [(UINavigationController *)ROOT_NAVIGATECONTROLLER popToRootViewControllerAnimated:YES]
#define ROOT_NAVIGATECONTROLLER_PRES(vc)    [(UINavigationController *)ROOT_NAVIGATECONTROLLER presentViewController: (vc)animated: YES completion:^{}]

#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif /* GlobalMacro_h */
