//
//  PlanDetailViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-11-21.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "PlanDetailViewController.h"
#import "JDplanViewController.h"
#import "ChufangViewController.h"

@interface PlanDetailViewController ()

@end

@implementation PlanDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"阶段计划";
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT-0) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:table];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(VIEW_WEIGHT-70, VIEW_HEIGHT-60, 50, 50);
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn"] forState:UIControlStateNormal];
    [homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    
}
-(void)HomeBtnPress
{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"planid++++++++++%@",_planId);
    if(!_DataDict){
       [self loadData];
    }
}

#pragma mark -
#pragma mark - Httprequest
-(void)loadData
{
    NSString *urlstr = URL_MyPlanDetail;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_planId,@"planid",nil];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        _DataDict = (NSDictionary *)obj;
        NSLog(@"%@",_DataDict);
        _jieduanArr = [_DataDict valueForKey:@"list"];
        _StarNum = [[_DataDict valueForKey:@"score"] integerValue];
        [table reloadData];
    };
    request.failureGetData = ^(void){
        [self showNoNetView];//显示没有网络页面
        [MBHUDView dismissCurrentHUD];
    };
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

-(void)setStarCell
{
//    [_cell1 setFrame:CGRectMake(0, 0, 320, 64)];
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (int i = 0; i<count; i++) {
//        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(64*i,0,  64, 64)];
//        subView.layer.borderWidth = 0.5;
//        subView.layer.borderColor = [[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]CGColor];
//        [arr addObject:subView];
//        [_cell1 addSubview:subView];
//    }

}

#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section==0||section==1){
        return 1;
    }else{
        return _jieduanArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell;
    UILabel *titleLable;
    UIImageView *img;
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, VIEW_WEIGHT-30, 30)];
        titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        titleLable.tag = 1000;
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [cell.contentView addSubview:titleLable];
        if(indexPath.section==1&&indexPath.row==0){
            for(int i=0;i<5;i++){
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(32*i+78, 5, 31, 30);
                btn.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
                btn.tag = i;
                [btn addTarget:self action:@selector(StarBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
            }
        }
    }
    if(indexPath.section==0){
        titleLable.text = [_DataDict valueForKey:@"infor"];
        //titleLable.numberOfLines = 0;
        //[titleLable sizeToFit];
    }else if (indexPath.section==1){
        titleLable.frame = CGRectMake(15, 5, VIEW_WEIGHT-30, 30);
        NSString *leverStr = @"评比星数  ★  ★  ★  ★  ★";
        //leverStr = [leverStr substringToIndex:(5+_StarNum*3)];
        NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc]initWithString: leverStr];
        NSLog(@"+++++++%@",str1);
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4,_StarNum*3)];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange((4+_StarNum*3),str1.length-_StarNum*3-4)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:NSMakeRange(4, str1.length-4)];
        titleLable.attributedText = str1;

    }else if (indexPath.section==2){
        
        img = [[UIImageView alloc]initWithFrame:CGRectMake(7, 3, 33, 20)];
        long long nowData =[[ManageVC TimeToTimePr:[NSDate date] WithFormat:@"YYYY-MM-dd"] longLongValue];//今天的时间戳
        long long startTime =[[[_jieduanArr objectAtIndex:indexPath.row] valueForKey:@"startdate"] longLongValue];
        long long endTime = [[[_jieduanArr objectAtIndex:indexPath.row] valueForKey:@"enddate"] longLongValue];
        if(nowData>=startTime&&nowData<=endTime){//正在执行
            img.image = [UIImage imageNamed:@"执行中"];
        }else if (nowData>endTime){//已完成
            img.image = [UIImage imageNamed:@"已完成"];
        }else if (nowData<startTime){//未开始
            img.image = [UIImage imageNamed:@"未开始"];
        }
        
        [cell addSubview:img];
        
        titleLable.frame = CGRectMake(45, 0, VIEW_WEIGHT-110, 35);
        titleLable.textColor =[UIColor grayColor] ;
        titleLable.font = [UIFont systemFontOfSize:13.];
        //追加标题时间@"第一阶段 2014-08-10至2014-08-28"
        NSString *textStr =[[_jieduanArr objectAtIndex:indexPath.row] valueForKey:@"title"];
        NSString *startTimeStr = [ManageVC timePrToTime:[[_jieduanArr objectAtIndex:indexPath.row] valueForKey:@"startdate"]];
        NSString *endTimeStr = [ManageVC timePrToTime:[[_jieduanArr objectAtIndex:indexPath.row] valueForKey:@"enddate"]];
        
        titleLable.text = [NSString stringWithFormat:@"%@ %@至%@",textStr,startTimeStr,endTimeStr];
        [cell addSubview:titleLable];
        
        UIButton *calenderBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WEIGHT-65,-3,40, 40)];
        calenderBtn.tag = [[[_jieduanArr objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        [calenderBtn setImage:[UIImage imageNamed:@"日历"] forState:UIControlStateNormal];
        [calenderBtn addTarget:self action:@selector(CalenderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:calenderBtn];
        
        UIButton *yizhuBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WEIGHT-38, -3, 40, 40)];
        yizhuBtn.tag = [[[_jieduanArr objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        [yizhuBtn setImage:[UIImage imageNamed:@"写吧"] forState:UIControlStateNormal];
        [yizhuBtn addTarget:self action:@selector(YizhuBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:yizhuBtn];
    }
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        UITableViewCell *cell = (UITableViewCell *)[self tableView:table cellForRowAtIndexPath:indexPath];
        UILabel *lab = (UILabel *)[cell viewWithTag:1000];
        if(HEIGHT_VIEW(lab)>100){
            return HEIGHT_VIEW(lab)+10;
        }else{
            return 100;
        }
    }else if (indexPath.section==1){
        return 40;
    }else{
        return 35;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, VIEW_WEIGHT+2, 30)];
    view.backgroundColor = [UIColor whiteColor];
    if(section==2){
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        lable.text = @"   历史记录";
        lable.textColor = [UIColor blackColor];
        lable.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [view addSubview:lable];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2){
        return 30.;
    }else{
        return 10.;
    }
}

-(void)CalenderBtnPress:(UIButton *)btn
{
    JDplanViewController *jdPlanVC = [[JDplanViewController alloc]init];
    jdPlanVC.jieduanId = [NSString stringWithFormat:@"%ld",(long)btn.tag] ;
    [self.navigationController pushViewController:jdPlanVC animated:YES];
}
-(void)YizhuBtnPress:(UIButton *)btn
{
    ChufangViewController *chufangVC = [[ChufangViewController alloc]init];
    chufangVC.jieduanId = [NSString stringWithFormat:@"%ld",(long)btn.tag] ;
    [self.navigationController pushViewController:chufangVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)StarBtnPress:(UIButton *)btn
{
    NSLog(@"%d",btn.tag);
    NSString *urlstr = URL_MyPlanDetail;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_planId,@"planid",@(btn.tag+1),@"score",nil];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            _StarNum = btn.tag+1;
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:1];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [table reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict valueForKey:@"Errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
    request.failureGetData = ^(void){
    
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
