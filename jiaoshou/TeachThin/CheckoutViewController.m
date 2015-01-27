//
//  CheckoutViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "CheckoutViewController.h"
#import "OrderViewController.h"
@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"食物结算";
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


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectDict = [NSMutableDictionary dictionary];
    _selectrowArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self setlayout];
    [self loadDataList];
}
-(void)setlayout
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view)-40) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.view addSubview:table];
    
    
    footer = [[UIView alloc]initWithFrame:CGRectMake(-1, VIEW_HEIGHT-44, WIDTH_VIEW(self.view)+2, 44)];
    footer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    footer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    footer.layer.borderWidth = 0.5;
    
    [self.view addSubview:footer];
    Allprice = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, WIDTH_VIEW(self.view)/2, 34)];
    Allprice.text = @"总账单:￥0";
    Allprice.textColor = [UIColor blackColor];
    Allprice.textAlignment = NSTextAlignmentLeft;
    Allprice.font = [UIFont boldSystemFontOfSize:16.];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(WIDTH_VIEW(self.view)-80, 6,70, 32);
    sureBtn.layer.cornerRadius = 3;
    sureBtn.backgroundColor = RGBACOLOR(247., 47., 58., 1);
    [sureBtn setTitle:@"结算" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:Allprice];
    [footer addSubview:sureBtn];
   
}


#pragma mark -
#pragma mark - Httprequest
-(void)loadDataList
{
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    NSString  *uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString *urlstr = URL_FoodOrderList;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",nil];
    NSLog(@"%@____________%@",urlstr,pragma);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"%@",dict);
        if([[dict valueForKey:@"code"]isEqualToString:@"01"]){
            _DataArr = [NSMutableArray arrayWithArray:[dict valueForKey:@"list"]];
            
            _foodprice = [[dict valueForKey:@"total"] floatValue];
            Allprice.text = [NSString stringWithFormat:@"总账单:￥%.1lf",_foodprice];
            
            //整理数据
            [_DataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *foodid = [[_DataArr objectAtIndex:idx] valueForKey:@"cartid"];
                NSString *num = [[_DataArr objectAtIndex:idx] valueForKey:@"num"];
                [_selectDict setObject:num forKey:foodid];
                [_selectrowArr addObject:@(1)];
            }];
            [self PanduanTableArrCount];
        }else{
            [self InfoAlert:@"获取数据失败" ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [MBHUDView dismissCurrentHUD];
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
    [self loadDataList];
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
        infoLable.text = @"购物车为空！";
        infoLable.hidden = YES;
        [self.view addSubview:infoLable];
    }
    if(_DataArr.count==0){
        infoLable.hidden = NO;
    }else{
        infoLable.hidden = YES;
    }
    [table reloadData];
}






#pragma mark - tableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *Identifier = @"Cell";
    purchesCell *cell = [table dequeueReusableCellWithIdentifier:Identifier];
    if(cell==nil)
    {
        cell = [[purchesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.tag = indexPath.row+2000;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = [_DataArr objectAtIndex:indexPath.row];
    NSString *imgurl = [NSString stringWithFormat:@"%@",[dict valueForKey:@"picurl"]];
    cell.imgView.image = [UIImage imageNamed:imgurl];
    cell.imgView.backgroundColor = [UIColor yellowColor];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"title"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥:%@",[dict valueForKey:@"price"]];
    NSString *num = [_selectDict valueForKey:[dict valueForKey:@"cartid"]];
    cell.Numberlable.text = [NSString stringWithFormat:@"%@",num];
    
    //
    cell.selectBrn.tag = [indexPath row];
    if([[_selectrowArr objectAtIndex:indexPath.row] integerValue]==1){
       cell.selectBrn.selected = YES;
    }else{
        cell.selectBrn.selected = NO;
    }
    
    [cell.selectBrn addTarget:self action:@selector(selectFoodBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.reduceBtn.tag = [indexPath row];
    [cell.reduceBtn addTarget:self action:@selector(reduceFoodBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.addBtn.tag = [indexPath row];
    [cell.addBtn addTarget:self action:@selector(addFoodBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 35)];
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    
    UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 100, 25)];
    Label.textColor = [UIColor blackColor];
    Label.backgroundColor = [UIColor clearColor];
    Label.textAlignment = NSTextAlignmentLeft;
    Label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    Label.text = @"热菜";
    [view addSubview:Label];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

//设置单元格的可编辑状态
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//编辑单元格所执行的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除状态可执行的操作
    [tableView beginUpdates];
    //删除数据
    [self deleteDate:indexPath.row];
    //删除相应表格
    //[tableView deleteRowsAtIndexPaths:@[indexPath]   withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

-(void)selectFoodBtnPress:(UIButton *)btn
{
    if(btn.selected){
        btn.selected = NO;
        //1.标记
        _selectrowArr[btn.tag]=@(0);
        //2.扣钱
        float priceStr = [[[_DataArr objectAtIndex:btn.tag] valueForKey:@"price"] floatValue];
        NSInteger num = [[_selectDict valueForKey:[[_DataArr objectAtIndex:btn.tag] valueForKey:@"cartid"]] integerValue];
        _foodprice -=(priceStr *num);
        Allprice.text = [NSString stringWithFormat:@"总账单:￥%.1lf",_foodprice];
        
    }else{
        btn.selected = YES;
        
        _selectrowArr[btn.tag]=@(1);
        //2.扣钱
        float priceStr = [[[_DataArr objectAtIndex:btn.tag] valueForKey:@"price"] floatValue];
         NSInteger num = [[_selectDict valueForKey:[[_DataArr objectAtIndex:btn.tag] valueForKey:@"cartid"]] integerValue];
        _foodprice +=(priceStr *num);
        Allprice.text = [NSString stringWithFormat:@"总账单:￥%.1lf",_foodprice];
    }
}

-(void)reduceFoodBtnPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    purchesCell *cell =(purchesCell *) [table viewWithTag:btn.tag+2000];
    UILabel *lable = (UILabel *)[cell viewWithTag:1000];
    int num = [lable.text intValue];
    if(num>1){
        num -=1;
        lable.text = [NSString stringWithFormat:@"%d",num];
        [_selectDict setObject:@(num) forKey:[[_DataArr objectAtIndex:btn.tag] valueForKey:@"cartid"]];
        if([[_selectrowArr objectAtIndex:btn.tag] integerValue]){
            NSString *priceStr = [[_DataArr objectAtIndex:btn.tag] valueForKey:@"price"];
            _foodprice -=[priceStr floatValue];
            Allprice.text = [NSString stringWithFormat:@"总账单:￥%.1lf",_foodprice];
        }
    }
}
-(void)addFoodBtnPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    purchesCell *cell =(purchesCell *) [table viewWithTag:btn.tag+2000];
    UILabel *lable = (UILabel *)[cell viewWithTag:1000];
    int num = [lable.text intValue]+1;
    lable.text = [NSString stringWithFormat:@"%d",num];
    [_selectDict setObject:@(num) forKey:[[_DataArr objectAtIndex:btn.tag] valueForKey:@"cartid"]];
    if([[_selectrowArr objectAtIndex:btn.tag] integerValue]){
        NSString *priceStr = [[_DataArr objectAtIndex:btn.tag] valueForKey:@"price"];
        _foodprice +=[priceStr floatValue];
        Allprice.text = [NSString stringWithFormat:@"总账单:￥%.1lf",_foodprice];
    }
}


-(void)deleteDate:(NSInteger)row
{
    NSString *urlstr = URL_DelFoodToOrder;
    NSString *foodid = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:row] valueForKey:@"cartid"]];
    NSString *uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",foodid,@"id",nil];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"____del__%@",dict);
        if([[dict valueForKey:@"code"]isEqualToString:@"01"]){
            //删除成功
            //1.
            float priceStr = [[[_DataArr objectAtIndex:row] valueForKey:@"price"] floatValue];
            NSInteger num =  [[_selectDict valueForKey:[[_DataArr objectAtIndex:row] valueForKey:@"cartid"]] integerValue];;
            _foodprice -=(priceStr *num);
            Allprice.text = [NSString stringWithFormat:@"总账单:￥%.1lf",_foodprice];

            //2.
            [_selectDict removeObjectForKey:[[_DataArr objectAtIndex:row] valueForKey:@"cartid"]];
            [_selectrowArr removeObjectAtIndex:row];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_DataArr];
            [arr removeObjectAtIndex:row];
            _DataArr = [NSArray arrayWithArray:arr];
          
            //3.
            [self PanduanTableArrCount];
        }else{
            [self InfoAlert:[dict valueForKey:@"error"] ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [self showNoNetView];//显示没有网络页面
    };
}



-(void)sureBtnClick:(id)sender
{
    if(_foodprice>0){
        [self LoadSubmitData];
    }else{
        [self InfoAlert:@"请先选择购买物品" ok:@"知道了" cacel:nil];
    }
}



-(void)LoadSubmitData
{
    NSString *urlstr = URL_SubmitOrder;
    
    NSMutableDictionary *ordDict = [NSMutableDictionary dictionaryWithDictionary:_selectDict];
    [_selectrowArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue]==0) {
            [ordDict removeObjectForKey:[[_DataArr objectAtIndex:idx] valueForKey:@"cartid"]];
        }
    }];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ordDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *postStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    postStr = [postStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    postStr = [postStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //postStr = [postStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSLog(@"____%@",postStr);
//    postStr = pos(NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,                                    (CFStringRef)postStr, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
//    
//     NSString *newString = NSMakeCollectable((NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,  (CFStringRef)postStr, NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),CFStringConvertNSStringEncodingToEncoding()));
    //postStr = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",postStr,@"cartid",nil];
    NSLog(@"+++++++++++++%@+++++++%@",urlstr,pragma);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"____submit__%@",dict);
        if([[dict valueForKey:@"code"]isEqualToString:@"01"]){
            OrderViewController * orderVC = [[OrderViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }else{
            [self InfoAlert:[dict valueForKey:@"error"] ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [self showNoNetView];//显示没有网络页面
    };
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
