//
//  ApplyFriendControllerViewController.m
//  TeachThin
//
//  Created by myStyle on 14-11-28.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#import "ApplyFriendControllerViewController.h"
#import "ApplyFriendCell.h"
#import "ApplyEntity.h"
#import "ChatViewController.h"
#import "ChatListCell.h"
#import "NSDateFormatter+Category.h"
#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "EaseMobProcessor.h"
#import <SDWebImage/UIImageView+WebCache.h>

static ApplyFriendControllerViewController *controller = nil;

@interface ApplyFriendControllerViewController ()<ApplyFriendCellDelegate>
{
    NSInteger rowCount;
    ApplyFriendCell *applyFriendCell;
}
@end

@implementation ApplyFriendControllerViewController

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    
    return controller;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self initTableView];
    [self unregisterNotifications];
    [self registerNotifications];
    [self loadDataSourceFromLocalDB];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    self.dataArray = [NSMutableArray new];
    self.conversionDic = [NSMutableDictionary new];
    self.applyDic = [NSMutableDictionary new];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back_arow"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [self loadChatListData];
//    [self reloadDataSource];
    [self loadDataSourceFromLocalDB];
}

#pragma mark -  初始化tableView
-(void)initTableView{
    if (IS_IOS7) {
        self.edgesForExtendedLayout =UIRectEdgeNone ;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)loadDataSourceFromLocalDB
{
//    [self showHudInView:self.view hint:@"刷新数据..."];
//    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
//    if(loginName && [loginName length] > 0)
//    {
//        NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"receiverUsername = %@ and style = %i", loginName, ApplyStyleFriend];
//        [ApplyEntity deleteAllMatchingPredicate:deletePredicate];
//        
//        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"receiverUsername = %@", loginName];
//        NSFetchRequest *request = [ApplyEntity requestAllWithPredicate:searchPredicate];
//        NSArray *applyArray = [ApplyEntity executeFetchRequest:request];
//        [self.dataSource removeAllObjects];
//        [self.dataSource addObjectsFromArray:applyArray];
//        
//        NSLog(@">>>>>>>>>>loadDataSourceFromLocalDB>>>>>>>>%@",self.dataSource);
//        //[self reloadDataSource];
//        [self.tableView reloadData];
//        
//    }
//  [self hideHud];
    
    [self showHudInView:self.view hint:@"刷新数据..."];
//    [_dataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"receiverUsername = %@ and style = %i", loginName, ApplyStyleFriend];
        [ApplyEntity deleteAllMatchingPredicate:deletePredicate];
        
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"receiverUsername = %@", loginName];
        NSFetchRequest *request = [ApplyEntity requestAllWithPredicate:searchPredicate];
        NSArray *applyArray = [ApplyEntity executeFetchRequest:request];
        [self.dataSource addObjectsFromArray:applyArray];
        NSLog(@">>>>>>>>>>loadDataSourceFromLocalDB>>>>>>>>%@",self.dataSource);
        [self.tableView reloadData];
    }
    [self hideHud];

}

#pragma mark - dataSource
#pragma  mark - 处理好友请求的数据
- (void)reloadDataSource
{
    NSMutableString *buddyName = [NSMutableString new];
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    for (EMBuddy *buddy in buddyList) {
        if (buddy.followState != eEMBuddyFollowState_NotFollowed) {
            if (![buddy.username isEqualToString:[MyMD5 md5HexDigest:[ManageVC sharedManage].uid]]) {
                [buddyName appendString:[NSString stringWithFormat:@",%@",buddy.username]];
                NSLog(@">>>>>>>>>>>>>>>>好友请求的信息：%@-------%@",buddy,buddy.username);
                NSLog(@">>>>>>>>>>>>>>>>好友拼接字符串：%@",buddyName);
            }
        }
    }
    [self.dataSource removeAllObjects];
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:buddyName,@"username", nil];
    NSString *url = URL_conversion;
    JSHttpRequest *request = [[JSHttpRequest alloc] init];
    [request StartWorkPostWithurlstr:url pragma:postDic ImageData:nil];
    request.successGetData = ^(id obj){
        [self hideHud];
        NSString *code = [obj valueForKey:@"code"];
        if ([code isEqualToString:@"01"]) {
            self.applyDic = [obj valueForKey:@"list"];
            NSLog(@">>>>>self.applyDic__________>>>>>>>>>>>>>%@", self.applyDic);
            for (NSDictionary *dic in self.applyDic) {
                [self.dataSource addObject:dic];
            }
            [self.tableView reloadData];
        }
    };
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
#warning 此处为添加好友
        NSString *buddyName = [self.dataSource objectAtIndex:indexPath.row];
        NSDictionary *buddyDict = [self.applyDic valueForKey:buddyName];
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:[buddyDict valueForKey:@"uid"],@"uid2",[ManageVC sharedManage].uid,@"uid", nil];
        NSString * url = URL_addFriend;
        NSLog(@"%@_________%@",url,postDict);
        JSHttpRequest * request = [[JSHttpRequest alloc]init];
        [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
        request.successGetData = ^(id obj){
            NSString * code = [obj valueForKey:@"code"];
            NSLog(@"%@",obj);
            if ([code isEqualToString:@"01"]) {
                EMError *error;
              [[EaseMob sharedInstance].chatManager acceptBuddyRequest:buddyName error:&error];
                [self.dataSource removeObject:buddyName];
                [self.tableView reloadData];
//                [self save];
//                if (!error) {
//                    [self.dataSource removeObject:buddyName];
//                    [self.tableView reloadData];
//                    
//                }
            }else if ([code isEqualToString:@"00"]){
            }
        };
    }
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:@"正在发送申请..."];
    }
}


#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
//    NSLog(@">>>>>>>>apply  dictionary>>>>>%@",dictionary);
//    if (dictionary && [dictionary count] > 0) {
//        [self.dataSource addObject:dictionary];
//        [self.tableView reloadData];
//        
//        NSLog(@">>>>>apply self.dataSource有好友请求数据>>>>>>>>>>>>>：%@",self.dataSource);
//    }
    
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (NSInteger i = ([_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    [self save];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity *newEntity = [ApplyEntity createEntity];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.tableView reloadData];
            
            if (style != ApplyStyleFriend) {
                [self save];
            }
        }
    }

}

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (void)clear
{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}

#warning 处理cell的滑动效果
#pragma mark - 处理cell的滑动效果
-(void)setCanCustomEdit:(BOOL)canCustomEdit{
    if (_canCustomEdit != canCustomEdit) {
        _canCustomEdit = canCustomEdit;
        if (_canCustomEdit) {
            if (hitView == nil) {
                hitView = [[HitView alloc] init];
                hitView.delegate = self;
                hitView.frame = applyFriendCell.frame;
                NSString *vRectStr = NSStringFromCGRect(applyFriendCell.frame);
                NSLog(@"%@",vRectStr);
            }
            hitView.frame = applyFriendCell.frame;
            [self.view addSubview:hitView];
            
            self.tableView.scrollEnabled = NO;
        }else{
            applyFriendCell = nil;
            [hitView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
        }
    }
}

-(void)didCellWillShow:(id)aSender{
    applyFriendCell = aSender;
    self.canCustomEdit = YES;
}

-(void)didCellWillHide:(id)aSender{
    applyFriendCell = nil;
    self.canCustomEdit = NO;
}

-(void)didCellHided:(id)aSender{
    applyFriendCell = nil;
    self.canCustomEdit = NO;
}

-(void)didCellShowed:(id)aSender{
    applyFriendCell = aSender;
    self.canCustomEdit = YES;
    NSLog(@"调用Delegate");
}

#pragma mark HitViewDelegate
-(UIView *)hitViewHitTest:(CGPoint)point withEvent:(UIEvent *)event TouchView:(UIView *)aView{
    BOOL vCloudReceiveTouch = NO;
    CGRect vSlidedCellRect = [applyFriendCell convertRect:applyFriendCell.frame fromView:self.tableView];
    vCloudReceiveTouch = CGRectContainsPoint(vSlidedCellRect, point);
    if (!vCloudReceiveTouch) {
        [applyFriendCell hideMenuView:YES Animated:YES];
    }
    return vCloudReceiveTouch ? [applyFriendCell hitTest:point withEvent:event] : aView;
}

#warning 未读消息

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[声音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
//   [self reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES];
    [self loadChatListData];
//    [self reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
//    [self reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    TTAlertNoTitle(message);
}
//
- (void)didAcceptBuddySucceed:(NSString *)username{
//   [self reloadDataSource];
}

-(void)didUnreadMessagesCountChanged
{
    [self loadChatListData];
//    [self reloadDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    
    [self unregisterNotifications];
}

#pragma mark - public



-(void)loadChatListData
{
    [self showHudInView:self.view hint:@"刷新数据..."];
    self.dataArray = [self loadDataSource];
    NSMutableString *userNameStr = [NSMutableString new];
    for (EMConversation *conversion in self.dataArray) {
        [userNameStr appendString:[NSString stringWithFormat:@",%@",conversion.chatter]];
        NSLog(@"_______________________userName Str:%@",userNameStr);
    }
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:userNameStr,@"username", nil];
    
        NSString *url = URL_conversion;
        JSHttpRequest *request = [[JSHttpRequest alloc] init];
        [request StartWorkPostWithurlstr:url pragma:postDic ImageData:nil];
        request.successGetData = ^(id obj){
        [self hideHud];
        NSString *code = [obj valueForKey:@"code"];
        if ([code isEqualToString:@"01"]) {
            self.conversionDic = [obj valueForKey:@"list"];
            }
        };
    [self.tableView reloadData];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@">>>>>>>>>>>>%ld",self.dataSource.count);
    if (section == 0) {
        return [self.dataSource count];;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ApplyFriendCell";
        ApplyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
            NSString *buddyName = [self.dataSource objectAtIndex:indexPath.row];
            NSDictionary *buddyDict = [self.applyDic valueForKey:buddyName];
            [cell renderApplyCellWithDic:buddyDict];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if (indexPath.section == 1){
        static NSString *identify = @"chatListCell";
        ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        EMConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
        NSDictionary *dic = [self.conversionDic valueForKey:conversation.chatter];
        cell.name = [dic objectForKey:@"realname"];
        NSString *picUrl = [dic objectForKey:@"picurl"];
        //设置头像
        [cell.userImageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"chatListCellHead.png"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        cell.detailMsg = [self subTitleMessageByConversation:conversation];
        cell.time = [self lastMessageTimeByConversation:conversation];
        cell.unreadCount = [self unreadMessageCountByConversation:conversation];
        if (indexPath.row % 2 == 1) {
            cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && applyFriendCell == [tableView cellForRowAtIndexPath:indexPath]) {
        [applyFriendCell hideMenuView:YES Animated:YES ];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }else if (indexPath.section == 1){
        EMConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
        ChatViewController *chatController;
        NSDictionary *dic = [self.conversionDic valueForKey:conversation.chatter];
        NSString *picUrl = [dic valueForKey:@"picurl"];
        NSString *title = [dic objectForKey:@"realname"];
        NSString *chatter = conversation.chatter;
        chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:conversation.isGroup];
        chatController.title = title;
        chatController.receiverImg = picUrl;
        [conversation markAllMessagesAsRead:YES];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

@end
