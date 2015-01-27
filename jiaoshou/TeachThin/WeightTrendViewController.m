//
//  WeightTrendViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-24.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "WeightTrendViewController.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
@interface WeightTrendViewController ()



@end

@implementation WeightTrendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"量一量";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arow"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self getdate];
    [self loadData];
    
    
}

-(void)getdate
{
    
    _datetime = [ManageVC DateStrFromDate:[NSDate date] Withformat:@"yyyy-MM-dd"];
    _weektime = [ManageVC getWeekday:[NSDate date]];
    
}

-(void)loadData
{
    NSString * uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
   // NSString * uid = @"2";
     NSString * starttime = _datetime;
    NSString * url  = URL_Measure_Date;
    NSLog(@"%@",url);
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",starttime,@"starttime" ,nil];
    NSLog(@"%@",postDict);
    
    
    
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:URL_Measure_Date pragma:postDict ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
      
        NSString * result = [obj valueForKey:@"code"];
         NSLog(@"%@",obj);
        
        if ([result isEqualToString:@"00"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无数据" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }else if([result isEqualToString:@"01"])
        {
            _weiArr = [obj valueForKey:@"list"];
            _valueArr = [NSMutableArray array];
            _dateArr = [NSMutableArray array];
            for (NSDictionary * dict in _weiArr) {
                NSString * key = [dict allKeys][1];
                NSString * key0 = [dict allKeys][0];
                NSString* value =  [dict objectForKey:key];
                NSString * value0 = [dict objectForKey:key0];
                [_valueArr addObject:value];
                [_dateArr addObject:value0];
            
            }
         
            [ManageVC sharedManage].dateArr = [NSArray arrayWithObjects:_dateArr, nil];
            NSLog(@"^^^^^^^^%@",[ManageVC sharedManage].dateArr);
            
            
            
        }
         [self setlayout];         
        
    };
    request.failureGetData = ^(void){
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
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view)/4, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"请选择日期";
    
    
    
    UIImageView * btnimgv = [[UIImageView alloc]init];
    btnimgv.frame = CGRectMake(140, 15, 9, 5);
    btnimgv.image = [UIImage imageNamed:@"arrow"];
    
    
    dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = CGRectMake(VIEW_MAXX(label), 0, WIDTH_VIEW(self.view)/2, 35);
    dateBtn.backgroundColor = [UIColor clearColor];
    [dateBtn setTitle:_datetime forState:UIControlStateNormal];
    dateBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [dateBtn addSubview:btnimgv];


    
    
    
    header = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_VIEW(self.view), 40)];
    header.backgroundColor = RGBACOLOR(29, 35, 42, 1);
    [header addSubview:label];
    [header addSubview:dateBtn];
    
    [self.view addSubview:header];
    
   [self.view addSubview:[self chart1]];
    
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH_VIEW(self.view)-20, 40)];
    label1.text = @"默认显示一周,体重单位是kg";
    label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor whiteColor];
    
    
    
    footer = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_VIEW(self.view)-40, WIDTH_VIEW(self.view), 40)];
    footer.backgroundColor = [UIColor blackColor];
    
    [footer addSubview:label1];
    [self.view addSubview:footer];
    
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(WIDTH_VIEW(self.view)-70, HEIGHT_VIEW(self.view)-70, 56, 56);
    homeBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homeBtn"]];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
 
}
#pragma mark - Creating the charts

-(FSLineChart*)chart1 {
    
    // 在这里面传入数据的数组


    
    NSArray * arr = [NSArray arrayWithArray:_valueArr];
    NSLog(@"%@",_valueArr);
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(30, VIEW_MAXY(header)+40, [UIScreen mainScreen].bounds.size.width - 40, HEIGHT_VIEW(self.view)*5/12)];
  
    lineChart.gridStep = (int)arr.count;
    
    //横坐标显示的数据
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%lu",(unsigned long)item];
    };
    //纵坐标显示的数据
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
    
    [lineChart setChartData:arr];
    
    return lineChart;
}
-(void)HomeBtnPress
{
    
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
}

-(void)dateBtnClick:(id)sender
{
    NSLog(@"date");
    
    LZWCustomActionSheet *sheet = [[LZWCustomActionSheet alloc] initWithView:nil AndHeight:244];
    [sheet showInView:self.view];
    __weak WeightTrendViewController *vc = self;
    
    sheet.SureBtnPress = ^(NSString *time){
        
        _startDate = [NSString stringWithFormat:@"%@",time];
        _datetime = time;
        [dateBtn setTitle:_datetime forState:UIControlStateNormal];
        
        [vc loadData];
        //[table reloadData];
        
    };
}



//-(void)endClick:(id)sender
//{
//    NSLog(@"end");
//    self.cas1 = [[CustomActionSheet alloc]initWithHeight:250 WithSheetTitle:@"请选择日期"];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done1)];
//    
//    rightButton.tintColor = RGBACOLOR(0, 94, 196, 1);
//    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(docancel1)];
//    leftButton.tintColor = RGBACOLOR(0, 94, 196, 1);
//    
//    
//    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    
//    NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,rightButton,nil];
//    
//    [self.cas1.toolbar setItems: array];
//    
//    self.dp1 = [[UIDatePicker alloc]init];
//    self.dp1.datePickerMode =  UIDatePickerModeDate;
//    self.dp1.bounds = CGRectMake(0, 0, WIDTH_VIEW(self.view), 100);
//    
//    [self.dp1 addTarget:self action:@selector(datechange1) forControlEvents:UIControlEventValueChanged];
//    [self.cas1 addSubview:self.dp1];
//    
//    [self.cas1 showFromRect:CGRectMake(0, HEIGHT_VIEW(self.view)-49, WIDTH_VIEW(self.view), 49) inView:self.view animated:YES];
//}
//#pragma 自定义得datepicker
//-(void)done1
//
//{
//    if(self.cas1.OKBtnbloack){
//        self.cas1.OKBtnbloack();
//    }
//    [self.cas1 dismissWithClickedButtonIndex:0 animated:YES];
//}
//
//-(void)docancel1
//{
//    [self.cas1 dismissWithClickedButtonIndex:0 animated:YES];
//}
//-(void)datechange1
//{
//    NSDate *selectedDate = [self.dp1 date];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:timeZone];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *dateString = [formatter stringFromDate:selectedDate];
//    
//    NSLog(@"%@",dateString);
//    
//   
//}

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
