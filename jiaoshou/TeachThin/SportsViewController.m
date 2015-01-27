//
//  SportsViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-11-19.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "SportsViewController.h"
#import "SpDetailViewController.h"
#import "SpSearchViewController.h"

@interface SportsViewController ()

#define PageSize 10

@end

@implementation SportsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"每日运动";
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SearchBtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(SearchBtnPress)];
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

-(void)SearchBtnPress
{
    SpSearchViewController *searchVC = [[SpSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    _listDict = [NSMutableDictionary dictionary];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WEIGHT, VIEW_HEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self addHeader];
    [self addFooter];
    [self.view addSubview:table];
    
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(VIEW_WEIGHT-70, VIEW_HEIGHT-60, 50, 50);
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn"] forState:UIControlStateNormal];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    _currentTypeIndext = 0;
    _currentPage = 1;
    [self loadSegData];
    [self SetMenuView];
    
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
}


-(void)SetMenuView
{
    MenuView = [[ListMenuView alloc]initWithFrame:CGRectMake(-100,64, 120, self.view.frame.size.height-64)];
    [MenuView setUserInteractionEnabled:YES];
    MenuView.ListTable.backgroundColor = RGBACOLOR(247.,247., 249., 1);
    MenuView.titleColor = [UIColor grayColor];
    MenuView.selectCellColor = [UIColor whiteColor];
    MenuView.ListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MenuView];
     MenuView.tapColor = RGBACOLOR(92., 155., 54., 1);
    __weak SportsViewController *vc = self;
    [MenuView setTapActionBlock:^(NSInteger Index) {
        NSLog(@"Taped is:%ld",(long)Index);
        
        NSString *key = [NSString stringWithFormat:@"%ld",(long)Index];
        if(Index!=vc.currentTypeIndext){
            vc.currentTypeIndext = Index;
            if([[vc.listDict valueForKey:key] count]==0){
                NSString *typeid = [[vc.segDataArr objectAtIndex:Index] valueForKey:@"id"];
                vc.currentPage=1;
                [vc loadListDataWithtypeid:typeid page:vc.currentPage];
            }else{
                vc.tableArr = [NSArray arrayWithArray:[vc.listDict valueForKey:key]];
                vc.currentPage = [[vc.listDict valueForKey:key] count]%PageSize==0?[[vc.listDict valueForKey:key] count]/PageSize+1:[[vc.listDict valueForKey:key] count]/PageSize+2;
                [table reloadData];
            }
        }
        
    }];
}

-(void)HomeBtnPress{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


#pragma mark - 
#pragma mark - Load
-(void)loadSegData
{
    NSString *urlstr = URL_menuListType(@"1");
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkWithUrlstr:urlstr];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----+++++++%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            //获取到分类列表的值
            _segDataArr = [dict valueForKey:@"result"];
            if(_segDataArr.count>0){
                NSString *typeid = [[_segDataArr firstObject] valueForKey:@"id"];
                [self loadListDataWithtypeid:typeid page:_currentPage];
            }else{
                [self InfoAlert:@"暂无任何分类数据" ok:@"知道了" cacel:nil];
            }
            [MenuView setListDataArr:_segDataArr];
        }else{
            [self InfoAlert:@"获取分类列表失败" ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [self InfoAlert:@"请检查网络" ok:@"知道了" cacel:nil];
    };
}

-(void)loadListDataWithtypeid:(NSString *)typeid page:(NSInteger)page
{
    NSString *urlstr = URL_SportListData(@"1",typeid,@(PageSize),@(page));
    NSLog(@"________________%@",urlstr);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkWithUrlstr:urlstr];
    request.successGetData = ^(id obj){
        [MBHUDView dismissCurrentHUD];
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"ListDataDict+++++++++++%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            NSArray *listArr = [dict valueForKey:@"result"];
             NSString *key = [NSString stringWithFormat:@"%ld",_currentTypeIndext];
            
            if(listArr.count>0){
                if(page==1){
                    [_listDict removeObjectForKey:key];
                }
                //存储数据
                NSMutableArray *temparr = [NSMutableArray arrayWithArray:[_listDict valueForKey:key]];
                [temparr addObjectsFromArray:listArr];
                [_listDict setObject:temparr forKey:key];
                _currentPage++;
            }else{
                [self InfoAlert:@"数据为空" ok:@"知道了" cacel:nil];
            }
            _tableArr = [NSArray arrayWithArray:[_listDict valueForKey:key]];
            [table reloadData];
        }else{
            [self InfoAlert:@"获取数据失败" ok:@"知道了" cacel:nil];
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




#pragma mark -
#pragma  mark - 下拉刷新
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    MJRefreshHeaderView *MJheader = [MJRefreshHeaderView header];
    MJheader.scrollView = table;
    MJheader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        _currentPage=1;
        NSString *typeid = [[vc.segDataArr objectAtIndex:_currentTypeIndext] valueForKey:@"id"];
        [vc loadListDataWithtypeid:typeid page:_currentPage];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    MJheader.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
    };
    MJheader.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                break;
                
            case MJRefreshStatePulling:
                break;
                
            case MJRefreshStateRefreshing:
                break;
            default:
                break;
        }
    };
    //##进入即刷新
    //[header beginRefreshing];
    freshHeader= MJheader;
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self NextPageClick:nil];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    freshFooter = footer;
}

-(void)NextPageClick:(id)sender
{
     NSString *typeid = [[self.segDataArr objectAtIndex:_currentTypeIndext] valueForKey:@"id"];
    [self loadListDataWithtypeid:typeid page:_currentPage];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [table reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}











#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SportCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell==nil){
        cell = [[SportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = [_tableArr objectAtIndex:indexPath.row];
    //cell.img.backgroundColor = [UIColor blueColor];
    [cell.img setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"picurl"]]];
    cell.titleLable.text = [dict valueForKey:@"title"];
    cell.detaillable.text = [dict valueForKey:@"description"];
    cell.detaillable.numberOfLines = 2;
    [cell.detaillable sizeToFit];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.;
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
    NSLog(@"_____selected_____");
    SpDetailViewController *detailVC = [[SpDetailViewController alloc]init];
    detailVC.newsid = [[_tableArr objectAtIndex:indexPath.row] valueForKey:@"id"];
    detailVC.type = @"1";
    detailVC.imageurl = [[_tableArr objectAtIndex:indexPath.row] valueForKey:@"picurl"];
    detailVC.title = @"运动详情";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
