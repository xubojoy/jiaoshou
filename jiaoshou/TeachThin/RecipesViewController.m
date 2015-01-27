//
//  RecipesViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14/11/12.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import "RecipesViewController.h"
#import "MyPlanViewController.h"
@interface RecipesViewController ()

@end

@implementation RecipesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"每日食谱";
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(_Senddatetime.length>0){
        NSLog(@"________%@",_Senddatetime);
        //表示从上个页面传值过来
        _datetime = _Senddatetime;
        [dateBtn setTitle:_datetime forState:UIControlStateNormal];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd"];
        NSDate *dateTime = [formatter dateFromString:_datetime];
        _weektime1 = [ManageVC getWeekday:dateTime];
        label1.text = [NSString stringWithFormat:@"%@",_weektime1];
    }
    [self PanduanTimeisRight];
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//   NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"uid"]);
//   [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uid"];
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    _arr = [[NSArray alloc]initWithObjects:@"早餐",@"早餐加餐",@"午餐",@"午餐加餐",@"晚餐", @"晚餐加餐", nil];
    NSLog(@"%@",_arr);
    [self getdate];
    [self setlayout];
}

-(void)getdate
{

    _datetime = [ManageVC DateStrFromDate:[NSDate date] Withformat:@"yyyy-MM-dd"];
    _weektime = [ManageVC getWeekday:[NSDate date]];
}

-(void)loadData
{
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    NSString * uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString * date = [NSString stringWithFormat:@"%@",_datetime];
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",date,@"date",nil];
    NSLog(@"%@",postDict);
    NSString * url = URL_Recipes_recipes;
     NSLog(@"*****%@",url);
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSLog(@"^^^^^^^%@",obj);
        NSDictionary *dataDict = (NSDictionary *)obj;
        _dict = [dataDict valueForKey:@"data"];
        [table reloadData];
        if([[_dict valueForKey:@"plan"] integerValue]==0 && _isRightTime){//未执行且时间小于今天
            planBtn.enabled = YES;
            noplanBtn.enabled = YES;
            [planBtn setImage:[UIImage imageNamed:@"plan"] forState:UIControlStateNormal];
            [noplanBtn setImage:[UIImage imageNamed:@"noplan"] forState:UIControlStateNormal];
        }else{//已经执行过
            [self setivalidPlanBtn:NO];
        }
        if([[dataDict valueForKey:@"code"] isEqualToString:@"201"]){
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dataDict valueForKey:@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [self setivalidPlanBtn:NO];
            [alert show];
        }
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
    [self loadData];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    
}





-(void)setlayout
{
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view)/4, 35)];
    label1.backgroundColor = [UIColor clearColor];
    if(_weektime!=nil){
        label1.text = [NSString stringWithFormat:@"%@",_weektime];
    }
    label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    
    UIImageView * btnimgv = [[UIImageView alloc]init];
    btnimgv.frame = CGRectMake(140, 15, 9, 5);
    btnimgv.image = [UIImage imageNamed:@"arrow"];
    
    
    dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = CGRectMake(VIEW_MAXX(label1), 0, WIDTH_VIEW(self.view)/2, 35);
    dateBtn.backgroundColor = [UIColor clearColor];
    [dateBtn setTitle:_datetime forState:UIControlStateNormal];
    dateBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [dateBtn addSubview:btnimgv];
    
    
    header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), 35)];
    header.backgroundColor = RGBACOLOR(34, 42, 51, 1);
    header.tag = 3000;
    [header addSubview:label1];
    [header addSubview:dateBtn];
    
    

    
    
    planBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    planBtn.frame = CGRectMake(WIDTH_VIEW(self.view)*1.5/8, 40, 73, 73);
   
    planBtn.layer.cornerRadius = 36.5;
    [planBtn addTarget:self action:@selector(PlanClick:) forControlEvents:UIControlEventTouchUpInside];
    [planBtn setImage:[UIImage imageNamed:@"plan"] forState:UIControlStateNormal];
    
    noplanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noplanBtn.frame = CGRectMake(WIDTH_VIEW(self.view)*4.6/8, 40, 73, 73);
    
    noplanBtn.layer.cornerRadius = 36.5;
    [noplanBtn addTarget:self action:@selector(noPlanClick:) forControlEvents:UIControlEventTouchUpInside];
    [noplanBtn setImage:[UIImage imageNamed:@"noplan"] forState:UIControlStateNormal];
 
    
    footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), 160)];
    footer.backgroundColor = RGBACOLOR(235, 235, 241, 1);
    

    [footer addSubview:planBtn];
    [footer addSubview:noplanBtn];
    
    
    if (!table) {
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, VIEW_oringeY, WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view)-VIEW_oringeY) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.tableHeaderView = header;
        table.tableFooterView = footer;
        [self.view addSubview:table];
    }
    
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(VIEW_WEIGHT-70, VIEW_HEIGHT-60, 50, 50);
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn"] forState:UIControlStateNormal];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
  
    
}


-(void)HomeBtnPress
{
    
   NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
   [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}


#pragma table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = (UITableViewCell *)[self tableView:table cellForRowAtIndexPath:indexPath];
    UILabel *lable = (UILabel *)[cell viewWithTag:1000];
    if (HEIGHT_VIEW(lable)<36) {
        return 56;
    }
    return HEIGHT_VIEW(lable)+20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [_arr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _celltitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, WIDTH_VIEW(cell.contentView)/4, 36)];
        _celltitle.textAlignment = NSTextAlignmentLeft;
        _celltitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        _celltitle.textColor = [UIColor blackColor];
        [cell.contentView addSubview:_celltitle];
        
        _cellcontent = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(_celltitle)+20, 10, WIDTH_VIEW(cell.contentView)*5/8-20, 36)];
       
        _cellcontent.backgroundColor = [UIColor clearColor];
        _cellcontent.textAlignment = NSTextAlignmentLeft;
        _cellcontent.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        [_cellcontent setLineBreakMode:NSLineBreakByWordWrapping];
        [_cellcontent setNumberOfLines:0];
        _cellcontent.tag = 1000;
        [cell.contentView addSubview:_cellcontent];
        
        
        
    }
    _celltitle.text = [_arr objectAtIndex:indexPath.section];
    switch (indexPath.section) {
        case 0:
        {
            
                  _cellcontent.text = [_dict valueForKey:@"breakfast"];
          
            
            
            
        }
            break;
            case 1:
        {
           
                _cellcontent.text =[_dict valueForKey:@"breakfastadd"];
          
            
           
           
        }
            break;
            case 2:
        {
          
                _cellcontent.text = [_dict valueForKey:@"lunch"];
        
            
           
        }
            break;
            case 3:
        {
           
                _cellcontent.text =[_dict valueForKey:@"lunchadd"];
            
            
           
        }
            break;
            case 4:
        {
            
                _cellcontent.text =[_dict valueForKey:@"dinner"];
           
            
           
        }
            break;
            case 5:
        {
         
                  _cellcontent.text = [_dict valueForKey:@"dinneradd"];
            
        }
            break;
        default:
            break;
    }
    

    return cell;
}


-(void)dateBtnClick:(id)sender
{
    NSLog(@"date");
    
    LZWCustomActionSheet *sheet = [[LZWCustomActionSheet alloc] initWithView:nil AndHeight:244];
    [sheet showInView:self.view];
    __weak RecipesViewController *vc = self;

    sheet.SureBtnPress = ^(NSString *time){
      
       
        
        [dateBtn setTitle:time forState:UIControlStateNormal];
        _datetime = [NSString stringWithFormat:@"%@",time];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd"];
        NSDate *dateTime = [formatter dateFromString:_datetime];
        _weektime1 = [ManageVC getWeekday:dateTime];
        label1.text = [NSString stringWithFormat:@"%@",_weektime1];
        [vc loadData];
        
        [self PanduanTimeisRight];
    };
}

-(void)PanduanTimeisRight
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSDate *dateTime = [formatter dateFromString:_datetime];
    //如果当前时间小于所选时间 执行按钮和为执行按钮不可以点击
    long long currentTime = (long long)[[NSDate date] timeIntervalSince1970];
    long long selectTime = (long long)[dateTime timeIntervalSince1970];
    NSLog(@"________________%lld,%lld",currentTime,selectTime);
    if(currentTime<selectTime){
        [self setivalidPlanBtn:NO];
        _isRightTime = NO;
    }else{
        [self setivalidPlanBtn:YES];
        _isRightTime = YES;
    }

}

-(void)setivalidPlanBtn:(BOOL)statu
{
    if(statu==YES){
        planBtn.enabled = YES;
        noplanBtn.enabled = YES;
        [planBtn setImage:[UIImage imageNamed:@"plan"] forState:UIControlStateNormal];
        [noplanBtn setImage:[UIImage imageNamed:@"noplan"] forState:UIControlStateNormal];
    }else{
        planBtn.enabled = NO;
        [planBtn setImage:[UIImage imageNamed:@"plan2"] forState:UIControlStateNormal];
        noplanBtn.enabled = NO;
        [noplanBtn setImage:[UIImage imageNamed:@"noplan2"] forState:UIControlStateNormal];
    }
}


-(void)PlanClick:(id)sender
{
    NSLog(@"提交食谱");
    
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
//    NSString * uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
//    NSString * date = _datetime;
    NSString * plan = [_dict valueForKey:@"id"];
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:plan,@"id",nil];
    NSLog(@"%@",postDict);
    NSString * url = URL_Recipes_plan;
    NSLog(@"*****%@",url);
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSLog(@"^^^^^%@",obj);
        NSInteger result =[[obj valueForKey:@"code"]integerValue] ;
        if (result==201) {
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的数据已经提交成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }else if (result==200)
        {
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"数据提交失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    };
    request.failureGetData = ^(void){
        [MBHUDView dismissCurrentHUD];
     
    };
    
    
    
    
    
}
-(void)noPlanClick:(id)sender
{
    MyPlanViewController * mpvc = [[MyPlanViewController alloc]init];
    mpvc.datetime = [NSString stringWithFormat:@"%@",_datetime];
    mpvc.dict = _dict;
    [self.navigationController pushViewController:mpvc animated:YES];
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
