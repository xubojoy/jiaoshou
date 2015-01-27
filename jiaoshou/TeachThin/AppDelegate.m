//
//  AppDelegate.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-19.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "IntroduceViewController.h"
#import "HomePageViewController.h"
#import "EaseMobProcessor.h"
#import "ApplyFriendControllerViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NSThread sleepForTimeInterval:2.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];

    // Override point for customization after application launch.
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(88, 155, 34, 1)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:      [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helveyica-Bold" size:20.0], NSFontAttributeName,nil]];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"First"]) {
        IntroduceViewController * IntroduceVC = [[IntroduceViewController alloc]init];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.window.rootViewController = IntroduceVC;
    }else
    {
        
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        UINavigationController * loginNC = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [loginNC setNavigationBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.window.rootViewController = loginNC;
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"uid"]);
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"First"];

    
    
    self.window.backgroundColor = [UIColor whiteColor];
//    [self registerRemoteNotification];
//    //初始化环信IM
//    [EaseMobProcessor init:application launchOptions:launchOptions];
//   [self loginStateChange:nil];

    
    NSLog(@">>>>>>>>>>>>>>>>>>>>init ease mob");
 
    [self registerRemoteNotification];
    
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"jiaoshouDevAPNS";
#else
    apnsCertName = @"jiaoshouProductAPNS";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"1309#jiaoshou" apnsCertName:apnsCertName];
    
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    [[[EaseMob sharedInstance] chatManager] setIsAutoFetchBuddyList:YES];
    
#warning 注册为SDK的ChatManager的delegate (及时监听到申请和通知)
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    //demo中此监听方法在MainViewController中
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
#warning 如果使用MagicalRecord, 要加上这句初始化MagicalRecord
    //demo coredata, .pch中有相关头文件引用
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"UIDemo"]];
    
    [self loginStateChange:nil];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerRemoteNotification{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
    
}



#pragma mark -notification相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@">>>>>>>>>>>>>>>>deviceToken:%@",deviceToken);
     [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//#warning SDK方法调用
//    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
//                                                    message:error.description
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    NSLog(@"receive");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iWeibo" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
    NSLog(@">>>>>>>applicationDidBecomeActive>>>>>>>>>>>");
    if ([ManageVC sharedManage].LoginState == YES) {
        [EaseMobProcessor login:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}


#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    
    
    NSLog(@"66666666666666666666666666666666666666666666------:%@",username);
    
    
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ 添加你为好友", username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyFriendControllerViewController shareController] addNewApply:dic];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
    if (!groupId || !username) {
        return;
    }
    
    NSString *groupName = groupId;
    if (!message || message.length == 0) {
        message = [NSString stringWithFormat:@"%@ 邀请你加入群组\'%@\'", username, groupName];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupName, @"groupId":groupId, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
    [[ApplyFriendControllerViewController shareController] addNewApply:dic];
}

#pragma mark - IChatManagerDelegate

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
}

#pragma mark - EMChatManagerPushNotificationDelegate

- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        TTAlertNoTitle(@"消息推送与设备绑定失败");
    }
}

#pragma mark - private

-(void)loginStateChange:(NSNotification *)notification
{
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {
//        [[ApplyFriendControllerViewController shareController] loadDataSourceFromLocalDB];
    }else{
      
    }
}

@end
