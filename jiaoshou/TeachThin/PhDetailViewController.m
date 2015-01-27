//
//  PhDetailViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "PhDetailViewController.h"
#import "CompareViewController.h"

@interface PhDetailViewController ()

@end

@implementation PhDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"拍一拍";
        self.view.backgroundColor = RGBACOLOR(235., 235., 241., 1);
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
    NSLog(@"++%@++++++%@+++arr+%@",[[FoodData sharedfoodData] DPversion],[[FoodData sharedfoodData] readDPDataArr], [[NSUserDefaults standardUserDefaults]objectForKey:@"FoodDPData"]);
    // Do any additional setup after loading the view.
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, VIEW_WEIGHT, 230)];
    imgView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:imgView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_MAXY(imgView)+20, VIEW_WEIGHT, 50)];
    lable.backgroundColor = [UIColor whiteColor];
    lable.text = @"    描述";
    lable.textColor = [UIColor blackColor];
    lable.layer.borderColor  =[[UIColor lightGrayColor] colorWithAlphaComponent:0.6].CGColor;
    lable.layer.borderWidth = 0.6;
    [self.view addSubview:lable];
    
    lable.userInteractionEnabled = YES;
    
    nametextBar = [[UISearchBar alloc]initWithFrame:CGRectMake(60, VIEW_MAXY(imgView)+24, VIEW_WEIGHT-160,45)];
    nametextBar.showsCancelButton = NO;
    nametextBar.returnKeyType = UIReturnKeyDone;
    nametextBar.delegate = self;
    nametextBar.placeholder = @"请输入名称                         ";
    [self.view addSubview:nametextBar];
    nametextBar.backgroundColor = [UIColor whiteColor];
    nametextBar.scopeBarBackgroundImage = [UIImage imageNamed:@"transparent"];
    nametextBar.backgroundImage = [UIImage imageNamed:@"transparent"];
    [nametextBar sizeToFit];
    
    
    UITextField *txfSearchField = [nametextBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    txfSearchField.clearButtonMode=UITextFieldViewModeNever;
    
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(55, VIEW_MAXY(lable), VIEW_WEIGHT-130, VIEW_HEIGHT-VIEW_MAXY(nametextBar)-100) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.hidden = YES;
    [self.view addSubview:table];
    
   
    UIButton *OKbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    OKbtn.frame = CGRectMake(20., VIEW_MAXY(lable)+60, VIEW_WEIGHT-40, 40);
    [OKbtn setTitle:@"确定" forState:UIControlStateNormal];
    OKbtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.];
    [OKbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [OKbtn setBackgroundColor:RGBACOLOR(249., 50., 60., 1)];
    OKbtn.layer.cornerRadius = 5.;
    [OKbtn addTarget:self action:@selector(OKBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKbtn];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    imgView.image = _TakeImg;
    [self loadMohuSearchData] ;
}
-(void)OKBtnPress
{
    if(nametextBar.text.length<=0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先输入菜名" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        CompareViewController *compareVC = [[CompareViewController alloc]init];
        compareVC.Foodname = nametextBar.text;
        compareVC.selfImg = _TakeImg;
        compareVC.Foodtype = _foodType;
        [self.navigationController pushViewController:compareVC animated:YES];
    }
}

#pragma mark - 
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, -160, VIEW_WEIGHT, VIEW_HEIGHT);
    }];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT);
    }];
    [nametextBar resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT);
    }];
    [nametextBar resignFirstResponder];
}


#pragma mark - 
#pragma mark - textFieldDelegate
-(void)loadMohuSearchData
{
    if(_foodType==0){//菜品
        NSString *version = [FoodData sharedfoodData].CPversion;
        [self loadCPFoodData:version];
    }else{//单品
        NSString *version = [FoodData sharedfoodData].DPversion;
        [self loadDPFoodData:version];
    }
}

-(void)loadCPFoodData:(NSString *)version
{
    NSString *urlstr = URL_FoodCPData(version);
    NSLog(@"++++%@",urlstr);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkWithUrlstr:urlstr];
    request.successGetData = ^(id obj){
        NSDictionary *Dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----%@",Dict);
        if([[Dict valueForKey:@"code"] isEqualToString:@"01"]){
            NSArray *listArr = [NSArray arrayWithArray:[Dict valueForKey:@"list"]];
            if(listArr.count>0){
                if([version isEqualToString:@"0"]){
                    //第一次获取存入到数据库中
                    [self WriteData:listArr];
                }else{
                    [self reformData:listArr];
                }
                //对获取到的数据做判断
                [[NSUserDefaults standardUserDefaults] setObject:[Dict valueForKey:@"version"] forKey:@"CPFoodversion"];//保存新的版本号
                [FoodData sharedfoodData].CPversion = [Dict valueForKey:@"version"];
            }
        }else{//数据没有做任何改动
            //{"code":"00"｝
            _tableFoodData = [[FoodData sharedfoodData] readCPDataArr];
        }
    };
    request.failureGetData = ^(void){
        
    };

}
-(void)loadDPFoodData:(NSString *)version
{
    NSString *urlstr = URL_FoodDPData(version);
    NSLog(@"++2222++%@",urlstr);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkWithUrlstr:urlstr];
    request.successGetData = ^(id obj){
        NSDictionary *Dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----%@",Dict);
        if([[Dict valueForKey:@"code"] isEqualToString:@"01"]){
            NSArray *listArr = [NSArray arrayWithArray:[Dict valueForKey:@"list"]];
            if(listArr.count>0){
                if([version isEqualToString:@"0"]){
                    //第一次获取存入到数据库中
                    [self WriteData:listArr];
                }else{
                    [self reformData:listArr];
                }
                //对获取到的数据做判断
                [[NSUserDefaults standardUserDefaults] setObject:[Dict valueForKey:@"version"] forKey:@"DPFoodversion"];//保存新的版本号
                [FoodData sharedfoodData].DPversion = [Dict valueForKey:@"version"];
                NSLog(@"_____2____%@",[FoodData sharedfoodData].DPversion);
            }
        }else{//数据没有做任何改动从数据库中读数据
            //{"code":"00"｝
            _tableFoodData = [[FoodData sharedfoodData] readDPDataArr];
        }
    };
    request.failureGetData = ^(void){
        
    };
}


-(void)WriteData:(NSArray *)arr
{
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *namedict = [NSDictionary dictionaryWithObject:[obj valueForKey:@"title"] forKey:[obj valueForKey:@"id"]];
        [nameArr addObject:namedict];
    }];
    if(_foodType==0){
        [[FoodData sharedfoodData] setCPDataArr:nameArr];
    }else{
        NSLog(@"______WritenameArr_______%@",nameArr);
        [[FoodData sharedfoodData] setDPDataArr:nameArr];
    }
    
    //页面数据获取
    _tableFoodData = [NSArray arrayWithArray:nameArr];
}

-(void)reformData:(NSArray *)arr
{
    //拿到所有数据
    NSMutableArray *refomArr;
    if(_foodType==0){
        refomArr = [NSMutableArray arrayWithArray:[[FoodData sharedfoodData] readCPDataArr]];
    }else{
        refomArr = [NSMutableArray arrayWithArray:[[FoodData sharedfoodData] readCPDataArr]];
    }
    
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *foodid = [obj valueForKey:@"id"];
        NSInteger foodstatu = [[obj valueForKey:@"state"] integerValue];
        if(foodstatu==1){//添加
             NSDictionary *namedict = [NSDictionary dictionaryWithObject:[obj valueForKey:@"title"] forKey:[obj valueForKey:@"id"]];
            [refomArr addObject:namedict];
        }
        for(int i=0;i<refomArr.count;i++){
            NSDictionary *dict = [refomArr objectAtIndex:i];
            if([foodid isEqualToString:[[dict allKeys] firstObject]]){
                if(foodstatu==2){//改变
                     NSDictionary *namedict = [NSDictionary dictionaryWithObject:[obj valueForKey:@"title"] forKey:foodid];
                    refomArr[i] = namedict;
                    return ;
                }else if(foodstatu==3){
                    [refomArr removeObjectAtIndex:i];
                    return;
                }
            }
        }
    }];
    if(_foodType==0){//存入数据库中
        [[FoodData sharedfoodData] setCPDataArr:refomArr];
    }else{
        [[FoodData sharedfoodData] setDPDataArr:refomArr];
    }
    //页面数据获取
    _tableFoodData = [NSArray arrayWithArray:refomArr];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
{
    [self searchPipeiMethed];
    if(searchBar.text.length>0){
        table.hidden = NO;
    }else {
        table.hidden = YES;
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [nametextBar resignFirstResponder];
}


-(void)searchPipeiMethed
{
    _tablearr = [NSMutableArray array];
    [_tableFoodData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //查找字符串
        NSString *searchstring=[[NSString alloc] initWithFormat:@"%@",[[obj allValues] firstObject]];
        NSLog(@"^^^^^^^^^^^^^^^^%@",searchstring);
        NSRange aa=[searchstring rangeOfString:nametextBar.text];
        if (aa.location != NSNotFound) {
            [_tablearr addObject:[[obj allValues] firstObject]];
        }
    }];
    
    [table reloadData];
}




#pragma mark -UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _tablearr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 0.4;
        cell.textLabel.font = [UIFont systemFontOfSize:13.];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.textLabel.text =[NSString stringWithFormat:@"%@",_tablearr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nametextBar.text = _tablearr[indexPath.row];
    table.hidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
