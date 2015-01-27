//
//  ProfossorSearchViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-12-15.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "ProfossorSearchViewController.h"

@implementation ProfossorSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 60.0, VIEW_WEIGHT, 45)];
    [mySearchBar setTintColor:[UIColor grayColor]];
    mySearchBar.barStyle=UIBarStyleDefault;
    mySearchBar.placeholder=@"这里有你想要的";
    [mySearchBar becomeFirstResponder];
    mySearchBar.delegate = self;
    self.navigationItem.titleView = mySearchBar;
    //[self.view addSubview:mySearchBar];
    [self showRecentTable:YES];
    
    Datatable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    Datatable.delegate = self;
    Datatable.dataSource = self;
    Datatable.tag = 1000;
    [self.view addSubview:Datatable];
    
}

//搜索框刚输入出发的事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    [self startWorking];
    
}

//添加Cancel事件：
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"12345465");
    
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self endWorking];
}
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self endWorking];
    if(searchBar.text.length>0){
        //添加为搜索历史
        NSMutableArray *_historyArr= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"]];
        if(![_historyArr containsObject:searchBar.text]){
            [_historyArr addObject:searchBar.text];
        }
        [[NSUserDefaults standardUserDefaults]setObject:_historyArr forKey:@"SearchHistory"];
        //请求数据
        [self loadListKey:searchBar.text];
    }
}

#pragma mark -
- (void)startWorking
{
    _viewBlackCover = [[UIView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WEIGHT, VIEW_HEIGHT-64)];
    _viewBlackCover.backgroundColor = [UIColor blackColor];
    _viewBlackCover.alpha = 0.0f;
    [self.view addSubview:_viewBlackCover];
    [UIView animateWithDuration:0.4f animations:^()
     {
         _viewBlackCover.alpha = 0.3f;
     }completion:^(BOOL f){}];
    
    if (![mySearchBar isFirstResponder])
    {
        [mySearchBar becomeFirstResponder];
    }else{}
    [ self setRecentKeyword:[NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"]]];
    [self showRecentTable:YES];
    
    _bIsWorking = YES;
}

- (void)endWorking
{
    _bIsWorking = NO;
    [_viewBlackCover removeFromSuperview];
    [self showRecentTable:NO];
}

- (void)setRecentKeyword:(NSArray *)arrRecentKeyword
{
    if (arrRecentKeyword)
    {
        _arrRecent = [NSArray arrayWithArray:arrRecentKeyword];
    }
    else
    {
        _arrRecent = nil;
    }
    if (searchtableView)
    {
        [searchtableView reloadData];
    }else{}
}

- (void)setKeyword:(NSString *)strKeyword
{
    if (mySearchBar)
    {
        [mySearchBar setText:strKeyword];
    }else{}
}


- (void)showRecentTable:(BOOL)bIsShow
{
    if (bIsShow && _arrRecent && (_arrRecent.count > 0))
    {
        if (!searchtableView)
        {
            searchtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT) style:UITableViewStylePlain];
            [self.view addSubview:searchtableView];
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 40)];
            UILabel *headLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, VIEW_WEIGHT, 40)];
            headLable.text = @"搜索历史";
            headLable.font = [UIFont boldSystemFontOfSize:16.];
            headLable.textColor = [UIColor darkGrayColor];
            [headView addSubview:headLable];
            searchtableView.tableHeaderView = headView;
            
            UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 240.0f)];
            footer.backgroundColor = [UIColor clearColor];
            searchtableView.tableFooterView = footer;
            UIButton *btnClearSearchRecord = [UIButton buttonWithType:UIButtonTypeCustom];
            btnClearSearchRecord.frame = CGRectMake(0.0f, 20.0f, footer.frame.size.width, 50.0f);
            [btnClearSearchRecord setTitle:@"清除搜索记录" forState:UIControlStateNormal];
            [btnClearSearchRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btnClearSearchRecord setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [btnClearSearchRecord addTarget:self action:@selector(btnClearSearchRecord:) forControlEvents:UIControlEventTouchUpInside];
            [footer addSubview:btnClearSearchRecord];
            
            searchtableView.backgroundColor = RGBACOLOR(232., 232., 232., 1);
            searchtableView.delegate = self;
            searchtableView.dataSource = self;
        }else{}
        searchtableView.hidden = NO;
        
        searchtableView.frame = CGRectMake(searchtableView.frame.origin.x, searchtableView.frame.origin.y+searchtableView.frame.size.height, searchtableView.frame.size.width, searchtableView.frame.size.height);
        [UIView animateWithDuration:0.3f animations:^()
         {
             searchtableView.frame = CGRectMake(0, 64, VIEW_WEIGHT, VIEW_HEIGHT-64);
         }];
    }
    else
    {
        if (searchtableView)
        {
            [searchtableView removeFromSuperview];
            searchtableView = nil;
        }else{}
    }
}
- (void)btnClearSearchRecord:(id)sender
{
    _arrRecent = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SearchHistory"];
    [searchtableView removeFromSuperview];
}


-(void)loadListKey:(NSString *)key
{
    //专家列表
    /*(depid:可选 科室id
     order:可选 为1按星级排序
     page:分页 可选默认1
     pagesize：可选 每页显示多少数据默认10
     key：搜索专家关键词可选。
     )*/
    NSString *urlstr = URL_ProfessorList;
    NSDictionary *pragma  = [NSDictionary dictionaryWithObject:key forKey:@"key"];
        NSLog(@"%@________%@",urlstr,pragma);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:nil ImageData:nil];
    request.successGetData = ^(id obj){
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----%@",dict);
        NSArray *arr =[dict valueForKey:@"list"];
        if(arr.count>0){
            _tableArr = [NSArray arrayWithArray:arr];
            [Datatable reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未匹配配到结果" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
    request.failureGetData = ^(void){
        //[self showNoNetView];//显示没有网络页面
        [MBHUDView dismissCurrentHUD];
    };
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==1000){
        return _tableArr.count;
    }else{
        NSInteger iCount = _arrRecent ? _arrRecent.count : 0;
        return iCount;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1000){
        specailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(cell==nil){
            cell = [[specailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = [_tableArr objectAtIndex:indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",[dict valueForKey:@"realname"]];
        NSString *cotent = [NSString stringWithFormat:@"职位 %@\n科室 %@",[dict valueForKey:@"job_title"],[dict valueForKey:@"depname"]];
        cell.cotentLabel.text = cotent;
        cell.cotentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.cotentLabel.numberOfLines = 0;
        [cell.cotentLabel sizeToFit];
        [cell.imgView setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"picurl"]]];
        return cell;
    }else{
        static NSString *CellIdentifier = @"SearchTypeCell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(12, 14, 12, 12)];
        [img setImage:[UIImage imageNamed:@"记录"]];
        [cell addSubview:img];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *strKeyword =[NSString stringWithFormat:@"      %@",_arrRecent[indexPath.row]];
        cell.textLabel.text = strKeyword;
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1000){
        NSLog(@"_____selected_____");
        ProdetailViewController *detailVC = [[ProdetailViewController alloc]init];
        detailVC.ProfessorDict = [_tableArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        NSString *strKeyword =[_arrRecent[indexPath.row]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉前后空格
        [mySearchBar setText:strKeyword];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1000){
        return 70.;
    }else{
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end