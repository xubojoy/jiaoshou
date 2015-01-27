//
//  EaseMobProcessor.h
//  TeachThin
//
//  Created by myStyle on 14-11-26.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeViewController.h"
@interface EaseMobProcessor : NSObject<IChatManagerDelegate,EMChatManagerPushNotificationDelegate>
{
    EMConnectionState _connectionState;
}
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, strong) MeViewController *mvc;
+(void)registUser;
+(void) login:(BOOL)delay;
+(void) logout;

+ (EaseMobProcessor *) sharedInstance;

@end
