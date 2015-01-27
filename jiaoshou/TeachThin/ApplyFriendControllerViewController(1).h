//
//  ApplyFriendControllerViewController.h
//  TeachThin
//
//  Created by myStyle on 14-11-28.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HitView.h"
typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@protocol ApplyFriendControllerViewControllerDelegate <NSObject>


@end

@interface ApplyFriendControllerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, IChatManagerDelegate,HitViewDelegate>
{
    HitView            *hitView;
}
@property (nonatomic,assign) BOOL canCustomEdit;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, weak) id<ApplyFriendControllerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, strong) NSMutableArray *userNameArray;
@property (nonatomic, strong) NSMutableArray *userImgArray;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) NSMutableDictionary *conversionDic;
@property (nonatomic, strong) NSMutableDictionary *applyDic;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)loadDataSourceFromLocalDB;

- (void)clear;
@end
