//
//  ShareServiece.h
//  loanCustomer
//
//  Created by zhangyinglong on 14/12/17.
//  Copyright (c) 2014年 yinglongzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

// 微信开放平台
#import <WXApi.h>

#define WeChat_AppID @"wxa726ecb9afc7670d"
#define WeChat_AppSecret @"3ea13bf0c51d9a399ffb6f67ed1b9166"

// QQ开放平台
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#define Tencent_AppID @"1104581389"
#define Tencent_AppSecret @"QWNdHOz8mvHUgCyR"

typedef NS_ENUM(NSInteger, ShareType) {
    ShareType_WeChatSession = 1,
    ShareType_WeChatTimeLine,
    ShareType_QQ,
    ShareType_QZone,
    ShareType_SMS,
    ShareType_Mail,
};

typedef NS_ENUM(NSInteger, ShareContentType) {
    ShareContentType_Text,
    ShareContentType_WebPage,
    ShareContentType_Audio,
    ShareContentType_Video,
    ShareContentType_Image,
};

//微博登录及发送微博类容结果的回调
@protocol ShareServieceDelegate <NSObject>

@optional
//微博登录成功
- (void)shareManagerDidLogIn;
//微博登录失败
- (void)shareManagerDidLogInFail:(NSError *)error;
//微博退出登录成功
- (void)shareManagerDidLogOut;
//取消登录
- (void)shareManagerDidCancel;
//发送微博成功
- (void)shareManagerSendSuccess;
//发送微博失败
- (void)shareManagerSendFail:(NSError *)error;
//微信
- (void)sendStatusWithMessage:(NSString *)message;

@end

typedef void (^WechatResultBlock)(BOOL result, NSString *msg);
typedef void (^TencentQQResultBlock)(BOOL result, NSString *msg);
typedef void (^TencentQZoneResultBlock)(BOOL result, NSString *msg);
typedef void (^SMSResultBlock)(BOOL result, NSString *msg);
typedef void (^MailResultBlock)(BOOL result, NSString *msg);

@interface ShareServiece : NSObject<WXApiDelegate, TencentSessionDelegate, QQApiInterfaceDelegate>

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ShareServiece);

@property (nonatomic, weak) id<ShareServieceDelegate> delegate;

+ (void)reset;

+ (void)shareContent:(NSDictionary *)userInfo
           shareType:(ShareType)type
            complete:(void(^)(BOOL result, NSString *msg))complete;

- (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - WeChat

- (void)sendWeChatMessageTitle:(NSString*)title
                   description:(NSString *)description
                   contentType:(ShareContentType)type
                       WithUrl:(NSString*)url
                         image:(UIImage *)image
                     WithScene:(int)scene
                withCompletion:(WechatResultBlock)completion;

#pragma mark - Tencent

- (void)sendQQMessageTitle:(NSString*)title
               description:(NSString *)description
               contentType:(ShareContentType)type
                   WithUrl:(NSString*)url
                     image:(UIImage *)image
            withCompletion:(TencentQQResultBlock)completion;

- (void)sendQZoneMessageTitle:(NSString*)title
                  description:(NSString *)description
                  contentType:(ShareContentType)type
                      WithUrl:(NSString*)url
                        image:(UIImage *)image
               withCompletion:(TencentQZoneResultBlock)completion;

@end
