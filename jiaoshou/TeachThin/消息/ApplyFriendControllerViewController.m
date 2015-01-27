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
#import "ApplyEntity.h"
#import "ChatViewController.h"
#import "ChatListCell.h"
#import "NSDateFormatter+Category.h"
#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "EaseMobProcessor.h"
#import <SDWebImage/UIImageView+WebCache.h>


static ApplyFriendControllerViewController *controller = nil;
//两次提示的默认间隔
@interface ApplyFriendControllerViewController ()
{
//    NSInteger rowCount;
//    ApplyFriendCell *applyFriendCell;
    
}
@property (assign, nonatomic) NSInteger rowsCount;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
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
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    _dataSource = [[NSMutableArray alloc] init];
    self.dataArray = [NSMutableArray new];
    _userNameArray = [[NSMutableArray alloc] init];
    self.tempArray = [NSMutableArray new];
    self.conversionDic = [NSMutableDictionary new];
    self.applyDic = [NSMutableDictionary new];
    [self loadDataSourceFromLocalDB];
    [self loadChatListData];
//    [self initTableView];
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
    NSLog(@">>>>>>>>保存的数据>>>>>>>>%@",[ManageVC sharedManage].userNameArr);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back_arow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark -  初始化tableView
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WEIGHT, VIEW_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#warning 此处为处理好友添加请求
#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}
- (NSMutableArray *)userNameArray
{
    if (_userNameArray == nil) {
        _userNameArray = [NSMutableArray array];
    }
    
    return _userNameArray;
}

- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
}

#pragma mark - IChatManagerDelegate

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    NSLog(@">>>>>>好友申请的请求>>>>>>>%@",dictionary);
    NSString *username = [dictionary valueForKey:@"username"];
    [self.userNameArray addObject:username];
    [ManageVC sharedManage].userNameArr = self.userNameArray;
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameArray forKey:@"userNameArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@">>>>>self.userNameArray>>>>>>>:%@",self.userNameArray);
}

- (void)loadDataSourceFromLocalDB
{
    [self reloadAddFriendDataSource];
}

- (void)popViewControllerAnimated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    [self.conversation markAllMessagesAsRead:YES];
    [self.dataArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clear{
    [ManageVC sharedManage].userNameArr = nil;
    [self.tableView reloadData];
}

#pragma mark - dataSource

- (void)reloadAddFriendDataSource
{
    [self showHudInView:self.view hint:@"刷新数据..."];
    NSMutableString *userNameStr = [NSMutableString new];
    for (NSString *applyName in [ManageVC sharedManage].userNameArr) {
        [userNameStr appendString:[NSString stringWithFormat:@",%@",applyName]];
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
            self.applyDic = [obj valueForKey:@"list"];
            NSLog(@"_______________________self.applyDic:%@",self.applyDic);
            [self initTableView];
            [self.tableView reloadData];
        }
    };
}

//===============================================================================================================

#warning 未读消息

#pragma mark - private

- (NSMutableArray *)loadChatRecordListDataArray
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

//// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}
//
//// 得到最后消息文字或者类型
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
#warning 有未读消息是处理
#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self loadChatListData];
    [self.tableView reloadData];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    
    [self loadChatListData];
    [self.tableView reloadData];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
}


#pragma mark - public
-(void)loadChatListData
{
//    [self showHudInView:self.view hint:@"刷新数据..."];
    self.dataArray = [self loadChatRecordListDataArray];
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
//        [self hideHud];
        NSString *code = [obj valueForKey:@"code"];
        if ([code isEqualToString:@"01"]) {
            self.conversionDic = [obj valueForKey:@"list"];
            [self.tableView reloadData];
            }
        };
}

//==========================================这里是消息列表tableView的处===============================================
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[ManageVC sharedManage].userNameArr count];;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString* identity=@"cell-identity";
        ApplyFriendCell* cell=(ApplyFriendCell*)[tableView dequeueReusableCellWithIdentifier:identity];
//        if (!cell) {
            cell=[[ApplyFriendCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:identity
                                                delegate:self
                                             inTableView:tableView withRightButtonTitles:@[@"忽略",@"不同意",@"同意"]];
//        }
        
        NSString *buddyName = [[ManageVC sharedManage].userNameArr objectAtIndex:indexPath.row];
        NSDictionary *buddyDict = [self.applyDic valueForKey:buddyName];
        [cell renderApplyCellWithDic:buddyDict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (indexPath.section == 0 ) {
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
        [self.tableView reloadData];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

//处理侧滑动画及好友申请
//=================================================================================

#pragma mark - WKTableViewCellDelegate
-(void)buttonTouchedOnCell:(WKTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.row,(long)buttonIndex);
    
   if (buttonIndex==0){
       NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
       NSString *buddyName = [[ManageVC sharedManage].userNameArr objectAtIndex:indexPath.row];
       for (NSString *tempBuddyName in [[ManageVC sharedManage] userNameArr]) {
           if (![tempBuddyName isEqualToString:buddyName]) {
               [self.dataSource addObject:tempBuddyName];
           }
       }
       [ManageVC sharedManage].userNameArr = self.dataSource;
       [[NSUserDefaults standardUserDefaults] setObject:self.dataSource forKey:@"userNameArr"];
       [[NSUserDefaults standardUserDefaults] synchronize];
       [self.tableView setEditing:NO animated:YES];
       [self.tableView reloadData];
   }else if (buttonIndex == 1){
       NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
       NSString *buddyName = [[ManageVC sharedManage].userNameArr objectAtIndex:indexPath.row];
       EMError *error = nil;
       BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:buddyName reason:@"不同意添加你为好友" error:&error];
       if (isSuccess && !error) {
           NSLog(@"发送拒绝成功");
           for (NSString *tempBuddyName in [[ManageVC sharedManage] userNameArr]) {
               if (![tempBuddyName isEqualToString:buddyName]) {
                   [self.dataSource addObject:tempBuddyName];
               }
           }
           [ManageVC sharedManage].userNameArr = self.dataSource;
           [[NSUserDefaults standardUserDefaults] setObject:self.dataSource forKey:@"userNameArr"];
           [[NSUserDefaults standardUserDefaults] synchronize];
           [self.tableView setEditing:NO animated:YES];
           [self.tableView reloadData];
       }
   }
   else if (buttonIndex==2){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath.row < [[ManageVC sharedManage].userNameArr count]) {
            [self showHudInView:self.view hint:@"正在发送申请..."];
            if (indexPath.section == 0) {
#warning 此处为添加好友
                NSString *buddyName = [[ManageVC sharedManage].userNameArr objectAtIndex:indexPath.row];
                NSDictionary *buddyDict = [self.applyDic valueForKey:buddyName];
                NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:[buddyDict valueForKey:@"uid"],@"uid2",[ManageVC sharedManage].uid,@"uid", nil];
                NSString * url = URL_addFriend;
                NSLog(@"%@_________%@",url,postDict);
                JSHttpRequest * request = [[JSHttpRequest alloc]init];
                [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
                request.successGetData = ^(id obj){
                    [self hideHud];
                    NSString * code = [obj valueForKey:@"code"];
                    NSLog(@"%@",obj);
                    if ([code isEqualToString:@"01"]) {
                        NSLog(@">>>>>>>>>添加成功>>>>>>>>>>>>");
//                        [[NSNotificationCenter defaultCenter] postNotificationName:WKTableViewCellNotificationChangeToUnexpanded object:nil];
                        EMError *error;
                        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:buddyName error:&error];
                        for (NSString *tempBuddyName in [[ManageVC sharedManage] userNameArr]) {
                            if (![tempBuddyName isEqualToString:buddyName]) {
                                [self.dataSource addObject:tempBuddyName];
                            }
                        }
                        [ManageVC sharedManage].userNameArr = self.dataSource;
                        [[NSUserDefaults standardUserDefaults] setObject:self.dataSource forKey:@"userNameArr"];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                        [self.tableView setEditing:NO animated:YES];
                        [self.tableView reloadData];
                        NSLog(@">>>>>>>>>>>[ManageVC sharedManage].userNameArr>>>>>>%@",[ManageVC sharedManage].userNameArr);
                    }else if ([code isEqualToString:@"00"]){
                    }
                };
            }
        }
    }
    
}
//=================================================================================
@end
