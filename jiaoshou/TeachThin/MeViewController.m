//
//  MeViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14/11/12.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import "MeViewController.h"
#import "SetViewController.h"
#import "HealthFileViewController.h"
#import "PlanViewController.h"
#import "MyFamilyViewController.h"
#import "RaiseMeViewController.h"
#import "CollectionViewController.h"
#import "MyCheckViewController.h"
#import "MyorderViewController.h"
#import "ApplyFriendControllerViewController.h"
#import "EaseMobProcessor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MeViewController ()

@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
#warning 把self注册为SDK的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadApplyView) name:@"applicationDidEnterBackground" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@,,,,,,,,%@",[ManageVC sharedManage].userImg,[ManageVC sharedManage].niceName);
    if(headimg){
        if([ManageVC sharedManage].LoginState==NO){
            headimg.image = [UIImage imageNamed:@"headimg"];
            label.text = @"用户未登录";
        }else{
            NSString *imgurl = [ManageVC sharedManage].userImg;
            NSLog(@"_____________%@",imgurl);
            [headimg setImageWithURL:[NSURL URLWithString:imgurl]];
            label.text = [ManageVC sharedManage].niceName;
        }
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView * bgimgV =[[UIImageView alloc]init];
    bgimgV.frame = CGRectMake(0, 0, WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view));
    bgimgV.image = [UIImage imageNamed:@"mebg"];
    
    [self.view addSubview:bgimgV];
    
  
    [self setlayout];
    [self reloadApplyView];
}
#warning 此处处理好友请求信息
#pragma mark - 此处处理好友请求

// 统计未读消息数
-(void)didUnreadMessagesCountChanged
{
    [self reloadApplyView];
    [table reloadData];
}

#pragma mark - action

- (void)reloadApplyView
{
    
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    NSLog(@">>>>>>>>>>>>>>unreadCount>>>>>>>>>>>>>>>%ld",unreadCount);
    NSInteger count = [[ManageVC sharedManage].userNameArr count]+unreadCount;
    
    if (count == 0) {
        self.unapplyCountLabel.hidden = YES;
    }
    else
    {
        // 收到消息时，播放音频
        [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
        // 收到消息时，震动
        [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
        
        NSString *tmpStr = [NSString stringWithFormat:@"%ld", count];
        CGSize size = [tmpStr boundingRectWithSize:CGSizeMake(50,20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil].size;
        CGRect rect = self.unapplyCountLabel.frame;
        rect.size.width = size.width > 10 ? size.width : 10;
        self.unapplyCountLabel.text = tmpStr;
        self.unapplyCountLabel.frame = rect;
        self.unapplyCountLabel.hidden = NO;
    }
}

- (void)reloadGroupView
{
    [self reloadApplyView];
}
- (UILabel *)unapplyCountLabel
{
    if (_unapplyCountLabel == nil) {
        _unapplyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 10, 10)];
        _unapplyCountLabel.textAlignment = NSTextAlignmentCenter;
        _unapplyCountLabel.font = [UIFont systemFontOfSize:5];
        _unapplyCountLabel.backgroundColor = [UIColor redColor];
        _unapplyCountLabel.textColor = [UIColor whiteColor];
        _unapplyCountLabel.layer.cornerRadius = _unapplyCountLabel.frame.size.width / 2;
        _unapplyCountLabel.hidden = YES;
        _unapplyCountLabel.clipsToBounds = YES;
    }
    return _unapplyCountLabel;
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

-(void)setlayout
{
    UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 12, 21)];
    imgv.image = [UIImage imageNamed:@"backbtn"];
    
    UIImageView * imgv1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 21, 21)];
    imgv1.image = [UIImage imageNamed:@"setbtn"];
  
    
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, WIDTH_VIEW(self.view)/6, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addSubview:imgv];
    
    
    setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(WIDTH_VIEW(self.view)*5/6, 20, WIDTH_VIEW(self.view)/6, 44);
    setBtn.backgroundColor = [UIColor clearColor];
    [setBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn addSubview:imgv1];
    [setBtn addTarget:self action:@selector(photoChange) forControlEvents:UIControlEventTouchUpInside];

    
    headimg = [[UIImageView alloc]init];
    headimg.frame = CGRectMake(WIDTH_VIEW(self.view)*3/8, 25, WIDTH_VIEW(self.view)/4, WIDTH_VIEW(self.view)/4);
    headimg.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    headimg.layer.cornerRadius = WIDTH_VIEW(self.view)/8;
    headimg.layer.masksToBounds = YES;
    headimg.layer.borderColor = [UIColor whiteColor].CGColor;
    headimg.layer.borderWidth = 1.;
    if([ManageVC sharedManage].LoginState==NO){
        headimg.image = [UIImage imageNamed:@"headimg"];
    }else{
        NSString *imgurl = [ManageVC sharedManage].userImg;
        [headimg setImageWithURL:[NSURL URLWithString:imgurl]];
    }
    
    
    label  = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_VIEW(self.view)/4, VIEW_MAXY(headimg)+5, WIDTH_VIEW(self.view)/2, 30)];
    label.backgroundColor = [UIColor clearColor];
    if([ManageVC sharedManage].LoginState==NO){
        label.text = @"用户未登录";
    }else{
       label.text = [ManageVC sharedManage].niceName;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16.];
    label.textColor = [UIColor whiteColor];

    
    header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), 150)];
    
    [header addSubview:backBtn];
    [header addSubview:setBtn];
    [header addSubview:headimg];
    [header addSubview:label];
    

    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view)) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 45;
    [table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    table.scrollEnabled = YES;
    table.userInteractionEnabled = YES;
    table.tableHeaderView = header;
    table.tableFooterView = footer;
    table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mebg"]];
    [self.view addSubview:table];
  
}

#pragma table datasorce;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==2) {
        return 70;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 20;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section==0) {
        return 3;
    }else if (section==1){
        return 2;
    }else
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.section ==2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section==2||indexPath.section==3) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cellimg =[[UIImageView alloc]initWithFrame:CGRectMake(20, 12, 21, 21)];
        [cell.contentView addSubview:cellimg];
        
        celltitle = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(cellimg)+20, 7, WIDTH_VIEW(cell)*5/8, 30)];
        celltitle.textAlignment = NSTextAlignmentLeft;
        celltitle.font = [UIFont systemFontOfSize:16.0];
        [cell.contentView addSubview:celltitle];
    
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cellimg.image = [UIImage imageNamed:@"row1"];
                    celltitle.text = @"健康档案";
            
                }
                    break;
                    case 1:
                {
                    cellimg.image = [UIImage imageNamed:@"row2"];
                    celltitle.text = @"我的计划";
                }
                    break;
                    case 2:
                {
                    cellimg.image = [UIImage imageNamed:@"row3"];
                    celltitle.text = @"我的家人";
                }
                    break;
                case 3:
                {
                    cellimg.image = [UIImage imageNamed:@"row4"];
                    celltitle.text = @"养我";
                }
                    break;
                default:
                    break;
            }
        }
            break;
             case 1:
        {
            if (indexPath.row ==0) {
                cellimg.image = [UIImage imageNamed:@"row6"];
                celltitle.text = @"我的订单";
            }
            if (indexPath.row ==1) {
                cellimg.image = [UIImage imageNamed:@"row5"];
                celltitle.text = @"体检报告";
            }
        }
            break;
            case 2:
        {
            
            cellimg.hidden = YES;
            celltitle.hidden = YES;
            
            
            collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            collectBtn.frame = CGRectMake(60, 0, 70, 70);
            [collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [collectBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 13, 18, 13)];
            collectBtn.titleLabel.font = [UIFont systemFontOfSize:10.];
            [collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(53, -23, 0, 20)];
            [cell.contentView addSubview:collectBtn];
            
            messageBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
            messageBtn.frame = CGRectMake(200, 0, 70, 70);
            [messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
            [messageBtn setTitle:@"消息" forState:UIControlStateNormal];
            [messageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [messageBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 13, 18, 13)];
            messageBtn.titleLabel.font = [UIFont systemFontOfSize:10.];
            [messageBtn setTitleEdgeInsets:UIEdgeInsetsMake(53, -23, 0, 20)];
            [cell.contentView addSubview:messageBtn];
            [cell addSubview:self.unapplyCountLabel];
             
        }
            break;
            case 3:
        {
            if (indexPath.row ==0) {
                cellimg.image = [UIImage imageNamed:@"row5"];
                celltitle.text = @"退出登录";
            }
        }
            break;
        default:
            break;
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    HealthFileViewController * hfvc = [[HealthFileViewController alloc]init];
                    [self.navigationController pushViewController:hfvc animated:YES];
                    
                }
                    break;
                case 1:
                {
                    PlanViewController * planvc = [[PlanViewController alloc]init];
                    [self.navigationController pushViewController:planvc animated:YES];
                }
                    break;
                case 2:
                {
                    MyFamilyViewController * mfvc = [[MyFamilyViewController alloc]init];
                    [self.navigationController pushViewController:mfvc animated:YES];
                }
                    break;
                case 3:
                {
                    RaiseMeViewController * rmvc = [[RaiseMeViewController alloc]init];
                    [self.navigationController pushViewController:rmvc animated:YES];

                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row ==0) {
                MyorderViewController * ordervc = [[MyorderViewController alloc]init];
                [self.navigationController pushViewController:ordervc animated:YES];
            }
            if (indexPath.row ==1) {
                MyCheckViewController * rmvc = [[MyCheckViewController alloc]init];
                [self.navigationController pushViewController:rmvc animated:YES];
            }
        }
            break;
        case 3:{
            if (indexPath.row ==0) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uid"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginState"];
                [ManageVC sharedManage].LoginState=NO;
//                [ManageVC sharedManage].name=nil;
//                [ManageVC sharedManage].userSex=nil;
//                [ManageVC sharedManage].uid = nil;
                [EaseMobProcessor logout];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}
-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)photoChange
{
    SetViewController * setvc = [[SetViewController alloc]init];
    [self.navigationController pushViewController:setvc animated:YES];
}
-(void)collectBtnClick:(id)sender
{
    CollectionViewController * collectionVC = [[CollectionViewController alloc]init];
    [self.navigationController pushViewController:collectionVC animated:YES];
}
-(void)messageBtnClick:(id)sender
{
#warning 此处为添加
    [self.navigationController pushViewController:[ApplyFriendControllerViewController shareController] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
