//
//  professorViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-12-15.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "professorViewController.h"
#import "ProfossorSearchViewController.h"




@interface professorViewController ()

#define PageSize 1
@end

@implementation professorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"找专家";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
        self.navigationItem.leftBarButtonItem = backItem;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SearchBtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(SearchBtnPress)];
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
    ProfossorSearchViewController *searchVC = [[ProfossorSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _starPage=1;
    _kePage = 1;
    _currentKeshi=0;
    _KeProfessorDict = [NSMutableDictionary dictionary];
    _StarProfessorArr = [NSMutableArray array];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 40-1, VIEW_WEIGHT, VIEW_HEIGHT-40) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self addHeader];
    [self addFooter];
    
    _keshiSeg = [[KeshisegView alloc]initWithFrame:CGRectMake(0., 64., VIEW_WEIGHT, 40)];
    [self.view addSubview:_keshiSeg];

    __weak professorViewController *vc = self;
    _keshiSeg.SegBtntap = ^(NSInteger tag){
        NSLog(@"selcted:%ld",tag);
        if(tag==2000){
            //点击满意度排名
            if(vc.StarProfessorArr.count==0){
                vc.starPage = 1;
                //加载星级排名数据
                [vc loadListKeshiId:nil page:vc.starPage isOrder:@"1"];
            }else{
                vc.starPage = vc.StarProfessorArr.count%PageSize==0?vc.StarProfessorArr.count/PageSize+1:vc.StarProfessorArr.count/PageSize+2;
                vc.tableArr = [NSArray arrayWithArray:vc.StarProfessorArr];
                [table reloadData];
            }
        }else{
            //点击科室刷新列表
            if(tag==1000){
                tag=_currentKeshi;
            }
            vc.currentKeshi = tag;
            //NSLog(@"_________%ld",(long)tag);
            NSString *keshiId = [NSString stringWithFormat:@"%@",[[vc.keshiListArr objectAtIndex:tag] valueForKey:@"id"]];
            _currentKeshi = [keshiId integerValue];
            if([[vc.KeProfessorDict valueForKey:keshiId] count]==0){
                vc.kePage = 1;
                [vc loadListKeshiId:keshiId page:vc.kePage isOrder:nil];
            }else{
                
                vc.kePage = [[vc.KeProfessorDict valueForKey:keshiId] count]%PageSize==0?[[vc.KeProfessorDict valueForKey:keshiId] count]/PageSize+1:[[vc.KeProfessorDict valueForKey:keshiId] count]/PageSize+2;
                vc.tableArr = [NSArray arrayWithArray:[vc.KeProfessorDict valueForKey:keshiId]];
                [table reloadData];
            }
        }
    };
    //获取科室分类
    [self loadKeshiData];
    //首次加载全部科室
     vc.kePage = 1;
    [vc loadListKeshiId:@"0" page:vc.kePage isOrder:nil];
    
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(VIEW_WEIGHT-70, VIEW_HEIGHT-60, 50, 50);
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn"] forState:UIControlStateNormal];
    [homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
}


-(void)HomeBtnPress{
    
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


-(void)loadKeshiData
{
    NSString *urlstr = URL_KeshiList;
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:nil ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----%@",dict);
        _keshiListArr = [[NSMutableArray alloc]initWithArray:[dict valueForKey:@"list"]];
        [_keshiListArr insertObject:@{@"id":@"0",@"name":@"全部"} atIndex:0];
        [_keshiSeg setCotentWithItems:_keshiListArr];
    };
    request.failureGetData = ^(void){
    };
}

-(void)loadListKeshiId:(NSString *)Id page:(NSInteger)page isOrder:(NSString *)order
{
    //专家列表
    /*(depid:可选 科室id
     order:可选 为1按星级排序
     page:分页 可选默认1
     pagesize：可选 每页显示多少数据默认10
     key：搜索专家关键词可选。
     )*/
    NSString *urlstr = URL_ProfessorList;
    NSMutableDictionary *pragma  = [NSMutableDictionary new];
    if(Id.length>0){
        [pragma setObject:Id forKey:@"depid"];
    }

    [pragma setObject:@(page) forKey:@"page"];
    [pragma setObject:@(PageSize) forKey:@"pagesize"];//*************************************************************
    
    if(order.length>0){
        [pragma setObject:order forKey:@"order"];
    }
    NSLog(@"%@________%@",urlstr,pragma);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:nil ImageData:nil];
    request.successGetData = ^(id obj){
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----%@",dict);
        if([order isEqualToString:@"1"]){
        //星级排名
            NSArray *arr =[dict valueForKey:@"list"];
            if(arr.count>0){
                if(_starPage==1){
                    [_StarProfessorArr removeAllObjects];
                }
                _starPage++;
                [_StarProfessorArr addObjectsFromArray:arr];
            }
            _tableArr = [NSArray arrayWithArray:_StarProfessorArr];
            [table reloadData];
        }else{
        //科室专家列表
            NSArray *list = [NSMutableArray arrayWithArray:[dict valueForKey:@"list"]];
            
            NSString *keshiid = [NSString stringWithFormat:@"%ld",(long)_currentKeshi];
            if(list.count>0){
                if(_kePage==1){
                    [_KeProfessorDict removeObjectForKey:keshiid];
                }
                _kePage++;
                NSMutableArray *keshiData = [NSMutableArray arrayWithArray:[_KeProfessorDict valueForKey:keshiid]];
                [keshiData addObjectsFromArray:list];
                [_KeProfessorDict setValue:keshiData forKey:keshiid];
            }
            _tableArr = [NSArray arrayWithArray:[_KeProfessorDict valueForKey:keshiid]];
            [table reloadData];
        }
    };
    request.failureGetData = ^(void){
        //[self showNoNetView];//显示没有网络页面
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
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    //[self loadData];
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
        if(_keshiSeg.btn2.selected==YES)
        {
            _starPage=1;
            [vc loadListKeshiId:nil page:vc.starPage isOrder:@"1"];
        }else{
            _kePage = 1;
            NSString *str = [NSString stringWithFormat:@"%ld",(long)_currentKeshi];
            [vc loadListKeshiId:str page:vc.kePage isOrder:nil];
        }
        
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


- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [table reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
-(void)NextPageClick:(id)sender
{
    if(_keshiSeg.btn2.selected==YES)
    {
        [self loadListKeshiId:nil page:self.starPage isOrder:@"1"];
    }else{
        NSString *str = [NSString stringWithFormat:@"%ld",(long)_currentKeshi];
        [self loadListKeshiId:str page:self.kePage isOrder:nil];
    }
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
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"_____selected_____");
    ProdetailViewController *detailVC = [[ProdetailViewController alloc]init];
    detailVC.ProfessorDict = [_tableArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
