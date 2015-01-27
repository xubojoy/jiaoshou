//
//  EatingViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "EatingViewController.h"

@interface EatingViewController ()

@end

@implementation EatingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"饮食偏好";
        self.view.backgroundColor = [UIColor whiteColor];
        sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnClick)];
        self.navigationItem.rightBarButtonItem = sureBtn;
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [_postArr removeAllObjects];
    _postArr = [[NSMutableArray alloc]init];
    [table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [self loadData];
    [self setlayout];
    
}
-(void)loadData
{
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    
    NSString * url = URL_ZhuCe_list;
    
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:nil ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        NSLog(@"%@",obj);
        [MBHUDView dismissCurrentHUD];
        
        NSLog(@"%@",obj);
        _arr = [obj valueForKey:@"habits"];
        [table reloadData];
    };
    request.failureGetData = ^(void){
        [MBHUDView dismissCurrentHUD];
        [self showNoNetView];//显示没有网络页面
        
        
        
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
    
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    
}


-(void)setlayout
{
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, WIDTH_VIEW(self.view),VIEW_HEIGHT) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    table.bounces = NO;
    
    table.rowHeight = 44;
    [table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.view addSubview:table];
}
#pragma table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [_arr count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell;
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


    }
    cell.textLabel.text = [_arr objectAtIndex:indexPath.section];
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
    cell.textLabel.textColor=[UIColor blackColor];
    
    selectBtn = [GXSelectBtn buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, WIDTH_VIEW(cell), 44);
    selectBtn.backgroundColor = [UIColor clearColor];
    [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(8.0,8.0, 8.0, 8.0)];
    
    selectBtn.tag = 1000+indexPath.section;
    selectBtn.info =  [_arr objectAtIndex:indexPath.section];
    [selectBtn addTarget:self action:@selector(selectBtnPress:) forControlEvents:UIControlEventTouchUpInside];
     selectBtn.Btnimg.hidden = YES;
    [cell.contentView addSubview:selectBtn];
    selectBtn.selected = NO;
    [_postArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj==selectBtn.info ){
            selectBtn.selected = YES;
            NSLog(@"**************%ld",(long)indexPath.section);
        }
    }];
   
    
    return cell;
    
}
-(void)selectBtnPress:(id)sender
{
    //获取点击的按钮
    GXSelectBtn *btn = (GXSelectBtn *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.Btnimg.hidden = NO;
        [_postArr addObject:btn.info];
        NSLog(@"****************%@",_postArr);
        
    }else
    {
        btn.Btnimg.hidden = YES;
        [_postArr removeObject:btn.info];
        NSLog(@"****************%@",_postArr);
        
    }
    
    
}


-(void)sureBtnClick
{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"eating" object:_postArr];
     [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
