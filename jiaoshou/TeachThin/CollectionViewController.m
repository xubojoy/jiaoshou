//
//  CollectionViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-19.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

#define PageSize 3
@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的收藏";
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    if(_ListArr.count==0){
        _currentPage = 1;
       [self loadDataListWithPage:_currentPage];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _ListArr = [NSMutableArray array];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self addHeader];
    [self addFooter];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(VIEW_WEIGHT/2-25, VIEW_HEIGHT-60, 50, 50);
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn"] forState:UIControlStateNormal];
    [homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
}



#pragma mark -
#pragma mark - Httprequest
-(void)loadDataListWithPage:(NSInteger )page
{
    _uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString *urlstr = URL_CollectionList;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_uid,@"uid",@(PageSize),@"pagesize",@(page),@"page", nil];
    NSLog(@"++++++++++++++++%@",pragma);
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
            NSArray *arr = [NSArray arrayWithArray:[dict valueForKey:@"list"]];
            if(arr.count>0){
                if(_currentPage==1){
                    [_ListArr removeAllObjects];
                }
                [_ListArr addObjectsFromArray:arr];
                _currentPage++;
            }
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
    [self loadDataListWithPage:_currentPage];
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
        infoLable.text = @"收藏信息为空！";
        infoLable.hidden = YES;
        [self.view addSubview:infoLable];
    }
    if(_ListArr.count==0){
        infoLable.hidden = NO;
    }else{
        infoLable.hidden = YES;
    }
    [table reloadData];
}

-(void)HomeBtnPress{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
        [vc loadDataListWithPage:_currentPage];
        
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
    [self loadDataListWithPage:_currentPage];
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
    return _ListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SportCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell==nil){
        cell = [[SportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = [_ListArr objectAtIndex:indexPath.row];
    [cell.img setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"picurl"]]];
    cell.titleLable.text = [dict valueForKey:@"title"];
    cell.detaillable.text = [dict valueForKey:@"infor"];
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
    detailVC.newsid = [[_ListArr objectAtIndex:indexPath.row] valueForKey:@"id"];
    detailVC.type = [[_ListArr objectAtIndex:indexPath.row] valueForKey:@"type"];
    detailVC.imageurl = [[_ListArr objectAtIndex:indexPath.row] valueForKey:@"picurl"];
    if([[[_ListArr objectAtIndex:indexPath.row] valueForKey:@"type"] integerValue]==1){
        detailVC.title = @"运动详情";
    }else{
        detailVC.title = @"营养知识";
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

//设置单元格的可编辑状态
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//编辑单元格所执行的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
    
       //删除数据
    [self deleteDate:indexPath.row];
}

-(void)deleteDate:(NSInteger)row
{
    NSString *urlstr = URL_DeletCollectionData;
     NSString *artid = [NSString stringWithFormat:@"%@",[[_ListArr objectAtIndex:row] valueForKey:@"id"]];
    _uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_uid,@"uid",artid,@"id",nil];
    NSLog(@"_____url%@____pragma%@",urlstr,pragma);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"%@",dict);
        if([[dict valueForKey:@"code"]isEqualToString:@"01"]){
            //删除成功
            [_ListArr removeObjectAtIndex:row];
            _currentPage = _ListArr.count/PageSize +1;
            [self PanduanTableArrCount];

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


@end
