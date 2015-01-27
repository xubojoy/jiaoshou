//
//  EaseMobProcessor.m
//  TeachThin
//
//  Created by myStyle on 14-11-26.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "EaseMobProcessor.h"
#import "ApplyFriendControllerViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ManageVC.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface  EaseMobProcessor()

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end
@implementation EaseMobProcessor


+(void) login:(BOOL)delay{
    double delayInSeconds = delay?0:2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[EaseMobProcessor sharedInstance] doLogin];
    });
}

-(void) doLogin{
    
    NSLog(@">>>>>>>>>>>>>登陆了！！！！");
     NSLog(@">>>>>>>>>>>>%@, %@",[ManageVC sharedManage].name,[ManageVC sharedManage].pwd);
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[MyMD5 md5HexDigest:[ManageVC sharedManage].uid]
                                                        password:[ManageVC sharedManage].pwd
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         if (loginInfo && !error) {
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error)
             {
                 NSLog(@"环信登录成功");
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             };
             
         }else {
             NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:[ManageVC sharedManage].uid,@"uid",[ManageVC sharedManage].pwd,@"pwd", nil];
             
             NSString *url  = URL_Register_huanxin;
             
             JSHttpRequest *request = [[JSHttpRequest alloc] init];
             [request StartWorkPostWithurlstr:url pragma:postDic ImageData:nil];
             request.successGetData = ^(id obj){
                 NSLog(@"^^successGetData^^^%@",obj);
                 NSString * result = [obj valueForKey:@"code"];
                 if ([result isEqualToString:@"01"]) {
                     [EaseMobProcessor login:NO];
                 }else if ([result isEqualToString:@"00"]){
                     
                 }
             };
         }
     } onQueue:nil];
}

+(void)registUser{

    NSLog(@">>>>>>>>>>>>%@, %@",[ManageVC sharedManage].name,[ManageVC sharedManage].pwd);
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:[ManageVC sharedManage].name
                                                         password:[ManageVC sharedManage].pwd
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
         if (!error) {
             //TTAlertNoTitle(@"注册成功,请登录");
             //[EaseMobProcessor login:NO];//登录
         }else{
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                    // TTAlertNoTitle(@"连接服务器失败!");
                     break;
                 case EMErrorServerDuplicatedAccount:
                     //TTAlertNoTitle(@"您注册的用户已存在!");
                     //[EaseMobProcessor login:NO];
                     break;
                 case EMErrorServerTimeout:
                     //TTAlertNoTitle(@"连接服务器超时!");
                     break;
                 default:
                     //TTAlertNoTitle(@"注册失败");
                     break;
             }
         }
     } onQueue:nil];
    
}

//
+(void) logout{
    [[EaseMob sharedInstance].chatManager asyncLogoff];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        if (error) {
            [[ApplyFriendControllerViewController shareController] showHint:error.description];
        }
        else{
            [[ApplyFriendControllerViewController shareController] clear];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
    [ManageVC sharedManage].LoginState = NO;
}


#pragma mark - IChatManagerDelegate
// 将要开始自动登录
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo
                       error:(EMError *)error{
    
}
// 自动登录结束
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo
                      error:(EMError *)error{
    
}


#pragma mark - IChatManagerDelegate 好友变化

+ (EaseMobProcessor *) sharedInstance{
    static EaseMobProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[EaseMobProcessor alloc] init];
    }
    
    return sharedInstance;
}

//=================================================================================


#pragma mark - IChatMangerDelegate

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (unreadCount>0) {
        [self playSoundAndVibration];
    }
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    if (ret) {
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        
        do {
            if (options.noDisturbing) {
                NSDate *now = [NSDate date];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                                               fromDate:now];
                
                NSInteger hour = [components hour];
                //        NSInteger minute= [components minute];
                
                NSUInteger startH = options.noDisturbingStartH;
                NSUInteger endH = options.noDisturbingEndH;
                if (startH>endH) {
                    endH += 24;
                }
                
                if (hour>=startH && hour<=endH) {
                    ret = NO;
                    break;
                }
            }
        } while (0);
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = message.isGroup ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [[ApplyFriendControllerViewController shareController] showHint:@"有透传消息"];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"[图片]";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"[位置]";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"[音频]";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"[视频]";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您有一条新消息";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = @"你的账号登录失败，正在重试中... \n点击 '登出' 按钮跳转到登录页面 \n点击 '继续等待' 按钮等待重连成功";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:@"继续等待"
                                                  otherButtonTitles:@"登出",
                                  nil];
        alertView.tag = 99;
        [alertView show];
    }
}

#pragma mark - IChatManagerDelegate 好友变化
- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    
}

- (void)didRemovedByBuddy:(NSString *)username
{
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES];
    [[ApplyFriendControllerViewController shareController] loadChatListData];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    TTAlertNoTitle(message);
}

- (void)didAcceptBuddySucceed:(NSString *)username
{

}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    TTAlertNoTitle(message);
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已在其他地方登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 100;
        [alertView show];
    } onQueue:nil];
}

- (void)didRemovedFromServer {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已被从服务器端移除"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    [[ApplyFriendControllerViewController shareController] hideHud];
    [[ApplyFriendControllerViewController shareController] showHudInView:[ApplyFriendControllerViewController shareController].view hint:@"正在重连中..."];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    [[ApplyFriendControllerViewController shareController] hideHud];
    if (error) {
        [[ApplyFriendControllerViewController shareController] showHint:@"重连失败，稍候将继续重连"];
    }else{
        [[ApplyFriendControllerViewController shareController] showHint:@"重连成功！"];
    }
}

@end
