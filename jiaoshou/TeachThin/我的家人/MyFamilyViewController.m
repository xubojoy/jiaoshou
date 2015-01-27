//
//  MyFamilyViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-14.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "MyFamilyViewController.h"
#import "FamilyDetailViewController.h"
#import "ChatViewController.h"
#import "AddFriendController.h"
#import "ChineseToPinyin.h"
#import "ApplyFriendControllerViewController.h"

#define originalHeight 60.0f
#define newHeight 110.0f
#define isOpen @"110.0f"
#define KEY [NSString stringWithFormat:@"%i",indexPath.section]

@interface MyFamilyViewController ()
@property (strong, nonatomic) NSMutableArray *contactsSource;
@end

@implementation MyFamilyViewController
static NSString *contentIndentifer = @"Container";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的家人";
//        self.contactsSource = [NSMutableArray new];
        self.view.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    return self;
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
     __weak MyFamilyViewController *weakSelf = self;
     [[[EaseMob sharedInstance] chatManager] asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
         if (!error) {
             [weakSelf reloadDataSource];
         }
     } onQueue:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLayout];
//    ApplyFriendControllerViewController *afvc = [[ApplyFriendControllerViewController alloc] init];
//    afvc.delegate = self;
    

//    [self reloadDataSource];
    
}

#pragma mark - dataSource

- (void)reloadDataSource
{
    [self showHudInView:self.view hint:@"刷新数据..."];
    //获取好友列表
    self.contactsSource = [NSMutableArray new];
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:[ManageVC sharedManage].uid,@"uid", nil];
    NSString * url = URL_friend_list;
    NSLog(@"%@_________%@",url,postDict);

    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        //加载框消失
        [self hideHud];
        NSLog(@"______获取好友列表___%@",obj);
        NSString * code = [obj valueForKey:@"code"];
        if ([code isEqualToString:@"01"]) {
            
            for (NSDictionary *dic in [obj valueForKey:@"list"]) {
                NSString *uid = [dic valueForKey:@"uid"];
                if (![uid isEqualToString:[ManageVC sharedManage].uid]) {
                    [self.contactsSource addObject:dic];
                }
            }
            [self.table reloadData];
            
            
        }else if ([code isEqualToString:@"00"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无数据" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
}

-(void)setLayout
{
#pragma mark  - table
    _count = 0;
    _mHeight = originalHeight;
    _sectionIndex = 0;
    _dicClicked = [[NSMutableDictionary alloc]initWithCapacity:3];
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.table registerClass:[familyCell class] forCellReuseIdentifier:contentIndentifer];
    [self.view addSubview:self.table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mrk -
#pragma mark - UItableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contactsSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    familyCell *cell = [tableView dequeueReusableCellWithIdentifier:contentIndentifer];
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.MoreBtn.userInteractionEnabled = NO;
    cell.MoreBtn.tag = indexPath.section;
    NSLog(@">>>>>>>>>>>>查看排列顺序>>>>>>>>>>>>：%@",self.contactsSource);
    self.buddyDic = [self.contactsSource objectAtIndex:indexPath.section];
    self.realName = [self.buddyDic objectForKey:@"realname"];
   [cell renderFriendWithBuddyInfo:self.buddyDic];
    [cell.MoreBtn addTarget:self action:@selector(MoreBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //详细信息点击跳转
    cell.BtntapMethed = ^(NSInteger tag){
        if(tag==3){
            FamilyDetailViewController *detailVC3 = [[FamilyDetailViewController alloc]init];
            //传值
           NSDictionary *buddyDic = [self.contactsSource objectAtIndex:indexPath.section];
            detailVC3.userDataDict = buddyDic;
            [self.navigationController pushViewController:detailVC3 animated:YES];
        }else if (tag == 0){
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:self.realName]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能跟自己聊天" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }else if (tag==1){//发短讯
                NSString *phone = [[self.contactsSource objectAtIndex:indexPath.section] valueForKey:@"phone"];
                NSString *url = [NSString stringWithFormat:@"sms://%@",phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }else if (tag==2){//打电话
                UIWebView*callWebview =[[UIWebView alloc] init];
                NSString *phone = [[self.contactsSource objectAtIndex:indexPath.section] valueForKey:@"phone"];
                NSString *url = [NSString stringWithFormat:@"tel://%@",phone];
                NSURL *telURL =[NSURL URLWithString:url];
                [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                [self.view addSubview:callWebview];
            }
#warning 会话者
            NSString *username = [self.buddyDic valueForKey:@"username"];
            NSString *receiverImg = [self.buddyDic valueForKey:@"picurl"];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:username isGroup:NO];
            chatVC.title = self.realName;
            chatVC.receiverImg = receiverImg;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
        
    };
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    familyCell *targetCell = (familyCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (targetCell.frame.size.height < newHeight){
        [targetCell.MoreBtn setImage:[UIImage imageNamed:@"down_icon"] forState:UIControlStateNormal];
        [_dicClicked setObject:isOpen forKey:KEY];
    }
    else{
        [targetCell.MoreBtn setImage:[UIImage imageNamed:@"up_icon"] forState:UIControlStateNormal];
        [_dicClicked removeObjectForKey:KEY];
    }
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_dicClicked objectForKey:KEY] isEqualToString: isOpen])
        return newHeight;
    else
        return originalHeight;
}

//设置单元格的可编辑状态
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
return @"删除";

}
//编辑单元格所执行的操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        NSString *userName = [self.buddyDic objectForKey:@"username"];
        if ([userName isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能删除自己" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
#warning 处理删除好友
        [self.contactsSource removeObjectAtIndex:indexPath.section];
        [self.table setEditing:NO animated:YES];
        [self.table reloadData];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error;
            [[EaseMob sharedInstance].chatManager removeBuddy:userName removeFromRemote:YES error:&error];
            if (!error) {
                [[EaseMob sharedInstance].chatManager removeConversationByChatter:userName deleteMessages:YES];
            }
        });
    }
}
-(void)MoreBtnPress:(UIButton *)btn
{
    
}

@end
