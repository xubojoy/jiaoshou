//
//  ShopDetailViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-14.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ShopDetailViewController ()

@end

@implementation ShopDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title  = @"商品详情";
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setlayout];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
}


-(void)setlayout
{
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(20, 20, WIDTH_VIEW(self.view)-40, 40);
    sureBtn.layer.cornerRadius = 3;
    sureBtn.backgroundColor = RGBACOLOR(248., 38., 49., 1);
    [sureBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), 100)];
    [footer addSubview:sureBtn];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view)) style:UITableViewStyleGrouped];
    table.tableFooterView = footer;
  
    //[self.view addSubview:table];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadData];
}

-(void)loadData
{
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    NSDictionary *prama = [NSDictionary dictionaryWithObjectsAndKeys:_foodid,@"id", nil];
    [request StartWorkPostWithurlstr:URL_Food_Detail pragma:prama ImageData:nil];
    NSLog(@"%@",URL_FoodmenuType);
    request.successGetData = ^(id obj){
        [MBHUDView dismissCurrentHUD];
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----+++++++%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            _dataDict = [dict valueForKey:@"result"];
            table.delegate = self;
            table.dataSource = self;
            [self.view addSubview:table];
            //[table reloadData];
        }else{
            [self InfoAlert:@"获取获取失败" ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [MBHUDView dismissCurrentHUD];
        [self InfoAlert:@"请检查网络" ok:@"知道了" cacel:nil];
    };
}
-(void)InfoAlert:(NSString *)message ok:(NSString *)OK cacel:(NSString *)Cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:OK otherButtonTitles:Cancel, nil];
    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UIImageView * imgv;
    UILabel * Foodname;
    UILabel * Restaurantname;
    UILabel * price;
    UILabel * tel;
    UILabel * address;
    UILabel * content;
    
    
    
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
  
    }
    switch (indexPath.row) {
        case 0:
        {
            imgv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
            [imgv setImageWithURL:[NSURL URLWithString:[_dataDict valueForKey:@"picurl"]]];
            [cell.contentView addSubview:imgv];
            
            Foodname = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(imgv)+20, 10, 200, 20)];
            Foodname.font =  [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
            Foodname.text = [NSString stringWithFormat:@"%@",[_dataDict valueForKey:@"title"]];
            Foodname.textAlignment = NSTextAlignmentLeft;
            Foodname.textColor = [UIColor blackColor];
            [cell.contentView addSubview:Foodname];
            
            Restaurantname = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(imgv)+20, 30, 200, 20)];
            Restaurantname.textColor = [UIColor grayColor];
            Restaurantname.font =  [UIFont fontWithName:@"Helvetica" size:14.0f];
            Restaurantname.text = [NSString stringWithFormat:@"%@",[_dataDict valueForKey:@"shopname"]];
            Restaurantname.textAlignment = NSTextAlignmentLeft;
            Restaurantname.textColor = [UIColor grayColor];
            [cell.contentView addSubview:Restaurantname];
            
            price = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(imgv)+20, 50, 200, 20)];
            price.textColor = [UIColor grayColor];
            price.font =  [UIFont fontWithName:@"Helvetica" size:14.0f];
            price.text = [NSString stringWithFormat:@"优惠价:%@",[_dataDict valueForKey:@"promotion"]];

            price.textAlignment = NSTextAlignmentLeft;
            price.textColor = [UIColor grayColor];
            [cell.contentView addSubview:price];
        }
            break;
          case 1:
        {
            tel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, WIDTH_VIEW(self.view)-25, 20)];
            tel.font =  [UIFont fontWithName:@"Helvetica" size:14.0f];
            tel.textAlignment = NSTextAlignmentLeft;
            tel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            tel.text = [NSString stringWithFormat:@"电话:%@",[_dataDict valueForKey:@"tel"]];

            [cell.contentView addSubview:tel];
            
            address = [[UILabel alloc]initWithFrame:CGRectMake(15, 32, WIDTH_VIEW(self.view)-20, 20)];
            address.font =  [UIFont fontWithName:@"Helvetica" size:14.0f];
            address.text = [NSString stringWithFormat:@"地址:%@",[_dataDict valueForKey:@"address"]];
            address.textAlignment = NSTextAlignmentLeft;
            address.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            address.numberOfLines = 0;
            [address sizeToFit];
            address.tag = 3000;
            [cell.contentView addSubview:address];
        }
            break;
            case 2:
        {
            content = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, WIDTH_VIEW(self.view)-20, 40)];
            content.font =  [UIFont fontWithName:@"Helvetica" size:14.0f];
            content.textAlignment = NSTextAlignmentLeft;
            content.textColor = [UIColor grayColor];
            content.text = [NSString stringWithFormat:@"餐厅简介:%@",[_dataDict valueForKey:@"infor"]];
            content.numberOfLines = 0;
            content.lineBreakMode = NSLineBreakByCharWrapping;
            content.tag = 1000;
            [content sizeToFit];
            [cell.contentView addSubview:content];
        }
            break;
        default:
            break;
    }
    
    return cell;
}
#pragma table delegate;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row ==1) {
        UITableViewCell *cell =(UITableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
        UILabel *lable = (UILabel *)[cell viewWithTag:3000];
        return CGRectGetHeight(lable.frame)+40;
    }else {
        UITableViewCell *cell =(UITableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
        UILabel *lable = (UILabel *)[cell viewWithTag:1000];
        return CGRectGetHeight(lable.frame)+20;
    }
    
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 1.;
}


-(void)sureBtnClick:(UIButton *)btn
{
    
    [self loadGouwuData:_foodid];
}


-(void)PayChamgeAnimation
{
    [sureBtn setTitle:@"成功加入购物车" forState:UIControlStateNormal];
}

-(void)loadGouwuData:(NSString *)foodid
{
    NSString *uid = [ManageVC sharedManage].uid;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:foodid,@"id",uid,@"uid", nil];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:URL_AddFoodToOrder pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"searchDataDict-----%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            NSLog(@"添加成功");
            
            [self PayChamgeAnimation];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加到购物车失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
    request.failureGetData = ^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    };
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
