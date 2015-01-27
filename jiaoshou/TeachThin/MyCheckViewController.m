//
//  MyCheckViewController.m
//  TeachThin
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import "MyCheckViewController.h"
#import "CheckDetailViewController.h"

@interface MyCheckViewController ()

@end

@implementation MyCheckViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的体检报告";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
    self.navigationItem.leftBarButtonItem = backItem;
    [self setTableView];
    [self loadData];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}

-(void)setTableView
{
    if(!table){
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, VIEW_WEIGHT, VIEW_HEIGHT-25) style:UITableViewStyleGrouped];
        table.backgroundColor = RGBACOLOR(241., 242., 245., 1);
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
    }
}

#pragma mark -
#pragma mark - Httprequest
-(void)loadData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString *urlstr = URL_MyChecker;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        _Dict = (NSDictionary *)obj;
        NSLog(@"%@",_Dict);
        if([[_Dict valueForKey:@"code"]isEqualToString:@"01"]){
            NSArray *arr = [NSArray arrayWithArray:[_Dict valueForKey:@"result"]];
            _dataArr = [NSArray arrayWithArray:arr];
            
            NSLog(@"__________________%@",_dataArr);
            [self PanduanTableArrCount];
        }else{
            [self InfoAlert:@"获取数据失败" ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [self showNoNetView];//显示没有网络页面
    };
}


-(void)InfoAlert:(NSString *)message ok:(NSString *)OK cacel:(NSString *)Cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:OK otherButtonTitles:Cancel, nil];
    [alert show];
}

-(void)showNoNetView;
{
    [NonetView shareNetView].delegate = self;
    [self.view addSubview:[NonetView shareNetView]];
}
-(void)removeNonetView;
{
    [[NonetView shareNetView] removeFromSuperview];
}

-(void)NetViewReloadData
{
    NSLog(@"________reload____________");
    [self loadData];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
}


-(void)PanduanTableArrCount
{
    if(!infoLable){
        infoLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 230,VIEW_WEIGHT, 40)];
        infoLable.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        infoLable.backgroundColor = [UIColor clearColor];
        infoLable.textAlignment = NSTextAlignmentCenter;
        infoLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
        infoLable.text = @"您还未制定体检报告";
        infoLable.hidden = YES;
        [self.view addSubview:infoLable];
    }
    if(_dataArr.count==0){
        infoLable.hidden = NO;
    }else{
        infoLable.hidden = YES;
    }
    [table reloadData];
}

#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16.];
    cell.textLabel.textColor = [UIColor blackColor];
    NSString *timepr = [[_dataArr objectAtIndex:indexPath.row] valueForKey:@"addtime"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timepr longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *time = [formatter stringFromDate:date];
    cell.textLabel.text = time;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    CheckDetailViewController *detailVC = [[CheckDetailViewController alloc]init];
    detailVC.DataDict = [NSDictionary dictionaryWithDictionary:[_dataArr objectAtIndex:indexPath.row]];
    detailVC.name = [_Dict valueForKey:@"truename"];
    detailVC.sex = [_Dict valueForKey:@"sex"];
    detailVC.nation = [_Dict valueForKey:@"nation"];
    detailVC.age = [_Dict valueForKey:@"age"];
    detailVC.professor = [_Dict valueForKey:@"culture"];
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
