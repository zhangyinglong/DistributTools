//
//  ShareServiece.m
//  loanCustomer
//
//  Created by zhangyinglong on 14/12/17.
//  Copyright (c) 2014年 yinglongzhang. All rights reserved.
//

#import "ShareServiece.h"
#import <MessageUI/MessageUI.h>

#import "GlobalMacro.h"

@interface ShareServiece () < MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, copy) WechatResultBlock       wechatResultBlock;
@property (nonatomic, copy) TencentQQResultBlock    tencentQQResultBlock;
@property (nonatomic, copy) TencentQZoneResultBlock tencentQZoneResultBlock;
@property (nonatomic, copy) SMSResultBlock          smsResultBlock;
@property (nonatomic, copy) MailResultBlock         mailResultBlock;

@end

@implementation ShareServiece

SYNTHESIZE_SINGLETON_FOR_CLASS(ShareServiece)

- (instancetype)init {
    self = [super init];
    if (self) {
        // 向微信注册
        NSLog(@"微信SDK的版本号:%@", [WXApi getApiVersion]);
        [WXApi registerApp:WeChat_AppID];

        // 向QQ注册
        NSLog(@"QQ SDK的版本号:%@", [TencentOAuth sdkVersion]);
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:Tencent_AppID andDelegate:self];
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self] && [QQApiInterface handleOpenURL:url delegate:self];
}

- (void)resetAll {
    self.wechatResultBlock       = nil;
    self.tencentQQResultBlock    = nil;
    self.tencentQZoneResultBlock = nil;
    self.smsResultBlock          = nil;
    self.mailResultBlock         = nil;
}

+ (void)reset {
    [[ShareServiece sharedShareServiece] resetAll];
}

+ (void)shareContent:(NSDictionary *)userInfo
           shareType:(ShareType)type
            complete:(void (^)(BOOL result, NSString *msg))complete {
    NSString *title       = userInfo[@"title"] ? userInfo[@"title"] : kNullStr;
    NSString *description = userInfo[@"description"] ? userInfo[@"description"] : kNullStr;
    NSString *url         = userInfo[@"url"] ? userInfo[@"url"] : kNullStr;
    url = [url stringByReplacingOccurrencesOfString:@"\r\n" withString:kNullStr];
    UIImage          *image      = userInfo[@"image"] ? userInfo[@"image"] : nil;
    ShareContentType contentType = userInfo[@"contentType"] ? [userInfo[@"contentType"] integerValue] : ShareContentType_Text;
    switch (type) {
        case ShareType_WeChatSession:
        case ShareType_WeChatTimeLine: {
            [[ShareServiece sharedShareServiece] sendWeChatMessageTitle:title
                                                        description:description
                                                        contentType:contentType
                                                            WithUrl:url
                                                              image:image
                                                          WithScene:type-1
                                                     withCompletion:complete];
        }
            break;

        case ShareType_QQ: {
            [[ShareServiece sharedShareServiece] sendQQMessageTitle:title
                                                    description:description
                                                    contentType:contentType
                                                        WithUrl:url
                                                          image:image
                                                 withCompletion:complete];
        }
            break;

        case ShareType_QZone: {
            [[ShareServiece sharedShareServiece] sendQZoneMessageTitle:title
                                                       description:description
                                                       contentType:contentType
                                                           WithUrl:url
                                                             image:image
                                                    withCompletion:complete];
        }
            break;

        case ShareType_SMS: {
            [[ShareServiece sharedShareServiece] sendSMS:description complete:complete];
        }
            break;

        case ShareType_Mail: {
            [[ShareServiece sharedShareServiece] sendEmail:description complete:complete];
        }
            break;

        default:
            break;
    }
}

#pragma mark - WeChat

- (void)sendWeChatMessageTitle:(NSString *)title
                   description:(NSString *)description
                   contentType:(ShareContentType)type
                       WithUrl:(NSString *)url
                         image:(UIImage *)image
                     WithScene:(int)scene
                withCompletion:(WechatResultBlock)completion {
    self.wechatResultBlock = completion;
    // 发送内容给微信
    if ([WXApi isWXAppInstalled]) {
        if ([WXApi isWXAppSupportApi]) {
            //图片,链接,文体媒体消息分享
            WXMediaMessage *message = [WXMediaMessage message];
            message.title       = title;
            message.description = description;
            [message setThumbImage:image];

            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.scene = scene;
            switch (type) {
                case ShareContentType_Audio: {
                    WXMusicObject *music = [WXMusicObject object];
                    music.musicUrl      = url;
                    message.mediaObject = music;
                }
                    break;

                case ShareContentType_Video: {
                    WXVideoObject *vedio = [WXVideoObject object];
                    vedio.videoUrl      = url;
                    message.mediaObject = vedio;
                }
                    break;

                case ShareContentType_Image: {
                    WXImageObject *imageObj = [WXImageObject object];
//                    imageObj.imageUrl   = url;
                    message.mediaObject = imageObj;
                }
                    break;

                case ShareContentType_Text:
                case ShareContentType_WebPage:
                default: {
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl      = url;
                    message.mediaObject = ext;
                }
                    break;
            }
            req.message = message;

            // 发送请求
            [WXApi sendReq:req];
        }
        else {
            if (self.wechatResultBlock) {
                self.wechatResultBlock(NO, NSLocalizedString(@"您当前的微信版本不支持,请及时升级", nil));
            }
        }
    }
    else {
        if (self.wechatResultBlock) {
            self.wechatResultBlock(NO, NSLocalizedString(@"请先安装微信", nil));
        }
    }
}

- (void)onSentMediaMessage:(BOOL)bSent {
    // 通过微信发送消息后， 返回本App
    NSString *strMsg = [NSString stringWithFormat:@"发送结果:%u", bSent];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendStatusWithMessage:)]) {
        [self.delegate sendStatusWithMessage:strMsg];
    }
}

- (void)onSentAuthRequest:(NSString *)userName
              accessToken:(NSString *)token
               expireDate:(NSDate *)expireDate
                 errorMsg:(NSString *)errMsg {

}

- (void)onShowMediaMessage:(WXMediaMessage *)message {
    // 微信启动， 有消息内容。
    //    WXAppExtendObject *obj = message.mediaObject;

    //    shopDetailViewController *sv = [[shopDetailViewController alloc] initWithNibName:@"shopDetailViewController" bundle:nil];
    //    sv.m_sShopID = obj.extInfo;
    //    [self.navigationController pushViewController:sv animated:YES];
    //    [sv release];

    //    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
    //    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", message.title, message.description, obj.extInfo, message.thumbData.length];
}

- (void)onRequestAppMessage {
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
}

#pragma mark -
#pragma mark -WXApiDelegate

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        //        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        alert.tag = 1000;
        //        [alert show];
        //        [alert release];
    }
    else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        //        WXMediaMessage *msg = temp.message;
        //
        //        //显示微信传过来的内容
        //        WXAppExtendObject *obj = msg.mediaObject;
        //
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        //        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
    else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        //从微信启动App
        //        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        //        NSString *strMsg = @"这是从微信启动的消息";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
                //            case WXSuccess:strMsg = @"发送成功";break;
                //            case WXErrCodeCommon:strMsg = @"一般错误";break;
                //            case WXErrCodeUserCancel:strMsg = @"用户取消";break;
                //            case WXErrCodeSentFail:strMsg = @"发送失败";break;
                //            case WXErrCodeAuthDeny:strMsg = @"授权认证失败";break;
                //            case WXErrCodeUnsupport:strMsg = @"不支持";break;
            case WXSuccess: {
                if (self.wechatResultBlock) {
                    self.wechatResultBlock(YES, @"分享成功");
                }
            }
                break;
            case WXErrCodeCommon:
            case WXErrCodeSentFail:
            case WXErrCodeAuthDeny:
            case WXErrCodeUnsupport: {
                if (self.wechatResultBlock) {
                    self.wechatResultBlock(NO, @"分享失败");
                }
            }
                break;
            case WXErrCodeUserCancel:
            default: {
                if (self.wechatResultBlock) {
                    self.wechatResultBlock(NO, nil);
                }
            }
                break;
        }
    }
    else if ([resp isKindOfClass:[QQBaseResp class]]) {
        SendMessageToQQResp *qqResp = (SendMessageToQQResp *)resp;
        if (qqResp.type == ESENDMESSAGETOQQRESPTYPE) {
            if ([qqResp.result integerValue] == 0) {
                NSString *strMsg = @"分享成功";
                if (self.delegate && [self.delegate respondsToSelector:@selector(sendStatusWithMessage:)]) {
                    [self.delegate sendStatusWithMessage:strMsg];
                }
            }
            else {

            }
        }
    }
}

#pragma mark - SMS

//短信
- (void)sendSMS:(NSString *)message complete:(SMSResultBlock)complete {
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            self.smsResultBlock = complete;
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
            picker.body                   = message;
            [[[[UIApplication sharedApplication].delegate window] rootViewController] presentViewController:picker animated:YES completion:nil];
        }
        else {
            if (complete) {
                complete(NO, @"设备不支持短信功能");
            }
        }
    }
    else {
        if (complete) {
            complete(NO, @"设备不支持短信功能");
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:^{
        NSString *msg = nil;
        switch (result) {
            case MessageComposeResultSent: {
                msg = @"短信发送成功";
            }
                break;

            case MessageComposeResultCancelled: {

            }
                break;

            case MessageComposeResultFailed: {
                msg = @"短信发送失败";
            }
                break;

            default:
                break;
        }
        if (self.smsResultBlock) {
            self.smsResultBlock((result == MessageComposeResultSent), msg);
        }
    }];
}

#pragma mark - Email

- (void)sendEmail:(NSString *)message complete:(MailResultBlock)complete {
    Class messageClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendMail]) {
            self.mailResultBlock = complete;
            MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
            vc.mailComposeDelegate    = self;
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
            vc.modalTransitionStyle   = UIModalTransitionStyleCoverVertical;
            [vc setMessageBody:message isHTML:NO];
            [[[[UIApplication sharedApplication].delegate window] rootViewController] presentViewController:vc animated:YES completion:nil];
        }
        else {
            if (complete) {
                complete(NO, @"设备不支持邮件功能");
            }
        }
    }
    else {
        if (complete) {
            complete(NO, @"设备不支持邮件功能");
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
        NSString *msg = nil;
        switch (result) {
            case MFMailComposeResultSaved: {
                msg = @"邮件保存成功";
                break;
            }
            case MFMailComposeResultSent: {
                msg = @"邮件发送成功";
                break;
            }
            case MFMailComposeResultFailed: {
                msg = @"邮件发送失败";
                break;
            }
            case MFMailComposeResultCancelled:
            default: {
                break;
            }
        }
        if (self.mailResultBlock) {
            self.mailResultBlock((result == MFMailComposeResultSent), msg);
        }
    }];
}

#pragma mark - Tencent

- (void)sendQQMessageTitle:(NSString *)title
               description:(NSString *)description
               contentType:(ShareContentType)type
                   WithUrl:(NSString *)url
                     image:(UIImage *)image
            withCompletion:(TencentQQResultBlock)completion {
    self.tencentQQResultBlock = completion;
    if ([TencentOAuth iphoneQQInstalled]) {
        if ([TencentOAuth iphoneQQSupportSSOLogin]) {
            QQApiObject *urlObj = nil;
            switch (type) {
                case ShareContentType_WebPage: {
                    urlObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image)];
                }
                    break;

                case ShareContentType_Audio: {
                    urlObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image)];
                }
                    break;

                case ShareContentType_Video: {
                    urlObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image)];
                }
                    break;

                case ShareContentType_Image: {
                    urlObj = [QQApiWebImageObject objectWithPreviewImageURL:[NSURL URLWithString:url] title:title description:description];
                }
                    break;

                default: {             // 默认文本类型
                    urlObj = [QQApiTextObject objectWithText:description];
                }
                    break;
            }

            SendMessageToQQReq  *req = [SendMessageToQQReq reqWithContent:urlObj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            if (sent == EQQAPISENDSUCESS) {
                if (self.tencentQQResultBlock) {
                    self.tencentQQResultBlock(YES, @"分享成功");
                }
            }
            else {
                if (self.tencentQQResultBlock) {
                    self.tencentQQResultBlock(NO, @"分享失败");
                }
            }
        }
        else {
            if (self.tencentQQResultBlock) {
                self.tencentQQResultBlock(NO, @"您当前的QQ版本不支持,请及时升级");
            }
        }
    }
    else {
        if (self.tencentQQResultBlock) {
            self.tencentQQResultBlock(NO, @"请先安装QQ");
        }
    }
}

- (void)sendQZoneMessageTitle:(NSString *)title
                  description:(NSString *)description
                  contentType:(ShareContentType)type
                      WithUrl:(NSString *)url
                        image:(UIImage *)image
               withCompletion:(TencentQZoneResultBlock)completion {
    self.tencentQZoneResultBlock = completion;
    if ([TencentOAuth iphoneQQInstalled]) {
        if ([TencentOAuth iphoneQQSupportSSOLogin]) {
            QQApiObject *urlObj = nil;
            switch (type) {
                case ShareContentType_WebPage: {
                    urlObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image)];
                }
                    break;
                case ShareContentType_Audio: {
                    urlObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image)];
                }
                    break;

                case ShareContentType_Video: {
                    urlObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image)];
                }
                    break;

                case ShareContentType_Image: {
                    urlObj = [QQApiWebImageObject objectWithPreviewImageURL:[NSURL URLWithString:url] title:title description:description];
                }
                    break;

                default: {             // 默认文本类型
                    urlObj = [QQApiTextObject objectWithText:description];
                }
                    break;
            }
            SendMessageToQQReq  *req = [SendMessageToQQReq reqWithContent:urlObj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            if (self.tencentQZoneResultBlock) {
                if (sent == EQQAPISENDSUCESS) {
                    self.tencentQZoneResultBlock(YES, @"分享成功");
                }
                else {
                    self.tencentQZoneResultBlock(NO, @"分享失败");
                }
            }
        }
        else {
            if (self.tencentQZoneResultBlock) {
                self.tencentQZoneResultBlock(NO, @"您当前的QQ版本不支持,请及时升级");
            }
        }
    }
    else {
        if (self.tencentQZoneResultBlock) {
            self.tencentQZoneResultBlock(NO, @"请先安装QQ");
        }
    }
}

#pragma mark -TencentLoginDelegate
/**
 * 退出登录的回调
 */
- (void)tencentDidLogout {

}

/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions {
    return YES;
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth {
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth {

}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason {

}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse *)response {

}

/**
 * 社交API统一回调接口
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \param message 响应的消息，目前支持‘SendStory’,‘AppInvitation’，‘AppChallenge’，‘AppGiftRequest’
 */
- (void)responseDidReceived:(APIResponse *)response forMessage:(NSString *)message {

}

/**
 * post请求的上传进度
 * \param tencentOAuth 返回回调的tencentOAuth对象
 * \param bytesWritten 本次回调上传的数据字节数
 * \param totalBytesWritten 总共已经上传的字节数
 * \param totalBytesExpectedToWrite 总共需要上传的字节数
 * \param userData 用户自定义数据
 */
- (void)         tencentOAuth:(TencentOAuth *)tencentOAuth
              didSendBodyData:(NSInteger)bytesWritten
            totalBytesWritten:(NSInteger)totalBytesWritten
    totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
                     userData:(id)userData {

}

/**
 * 通知第三方界面需要被关闭
 * \param tencentOAuth 返回回调的tencentOAuth对象
 * \param viewController 需要关闭的viewController
 */
- (void)tencentOAuth:(TencentOAuth *)tencentOAuth doCloseViewController:(UIViewController *)viewController {

}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    //登录成功
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        //取消登录
    }
    else {
        //登录失败
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    //无网络连接，请设置网络
}

#pragma mark -QQApiInterfaceDelegate

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {
    NSLog(@"response = %@", response);
}

@end
