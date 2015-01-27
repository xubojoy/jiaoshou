//
//  YingyangViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-11-24.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "YingyangViewController.h"
#import "SpDetailViewController.h"

@interface YingyangViewController ()
#define PageSize 10
@end

@implementation YingyangViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"营养知识";
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
    _listDict = [[NSMutableDictionary alloc]init];
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WEIGHT, VIEW_HEIGHT-64)];
    backImg.image = [UIImage imageNamed:@"yingyangBack"];
    backImg.userInteractionEnabled = YES;
    [self.view addSubview:backImg];
 
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WEIGHT, VIEW_HEIGHT-64) collectionViewLayout:layout];
    collection.alwaysBounceVertical = NO;
    collection.backgroundColor = [UIColor clearColor];
    collection.dataSource = self;
    collection.delegate = self;
    [collection registerClass:[yingyangCell class]
    forCellWithReuseIdentifier:@"Cell"];
    [collection registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind: UICollectionElementKindSectionHeader  withReuseIdentifier: @"Header" ];
    [collection registerClass:[myfooterView class]  forSupplementaryViewOfKind: UICollectionElementKindSectionFooter  withReuseIdentifier: @"Footer" ];
    [self.view addSubview:collection];
    [self addHeader];
    [self addFooter];
   // collection.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 100)];
    searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(25, 20, VIEW_WEIGHT-50, 35)];
    searchbar.delegate = self;
    searchbar.placeholder = @"";
    searchbar.backgroundImage = [UIImage imageNamed:@"transparent"];
    searchbar.tintColor = RGBACOLOR(170., 138., 115., 1);
    
    searchbar.layer.cornerRadius = 10.;
    [searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarImg"] forState:UIControlStateNormal];
    
    [headerView addSubview:searchbar];
   [collection addSubview: headerView];

    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    MenuView = [[ListMenuView alloc]initWithFrame:CGRectMake(-100, 60, 120, self.view.frame.size.height-60)];
    [MenuView setUserInteractionEnabled:YES];
    MenuView.ListTable.backgroundColor = RGBACOLOR(46.,22., 9., 0.8);
    MenuView.ListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MenuView];
    MenuView.titleColor = [UIColor whiteColor];
    MenuView.tapColor = [UIColor whiteColor];
    MenuView.selectCellColor = RGBACOLOR(121., 57., 22., 1);
    __weak YingyangViewController *vc = self;
    [MenuView setTapActionBlock:^(NSInteger Index) {
        NSLog(@"Taped is:%ld",(long)Index);
         NSString *key = [NSString stringWithFormat:@"%ld",(long)Index];
        if(Index!=vc.currentTypeIndext){
            vc.currentTypeIndext = Index;
            if([[vc.listDict valueForKey:key] count]==0){
                NSString *typeid = [[vc.segDataArr objectAtIndex:Index] valueForKey:@"id"];
                vc.currentPage=1;
                [vc loadListDataWithtypeid:typeid page:1];
            }else{
                NSLog(@"^^^^^^^^^^^^^^^%@",vc.listDict);
                vc.collectionArr = [NSArray arrayWithArray:[vc.listDict valueForKey:key]];
                 vc.currentPage = [[vc.listDict valueForKey:key] count]%PageSize==0?[[vc.listDict valueForKey:key] count]/PageSize+1:[[vc.listDict valueForKey:key] count]/PageSize+2;
                [collection reloadData];
            }
        }
        
    }];

}


-(void)HomeBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}

#pragma mark -
#pragma mark - Load
-(void)loadSegData
{
    NSString *urlstr = URL_menuListType(@"0");
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkWithUrlstr:urlstr];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----+++++++%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
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
    NSString *urlstr = URL_SportListData(@"0",typeid,@(PageSize),@(page));
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
            _collectionArr = [NSArray arrayWithArray:[_listDict valueForKey:key]];
            [collection reloadData];

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
    MJheader.scrollView = collection;
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
    footer.scrollView = collection;
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
    [collection reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}








#pragma  mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return (_collectionArr.count%3==0)?(_collectionArr.count/3):(_collectionArr.count/3+1);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    NSInteger secnum = (_collectionArr.count%3==0)?(_collectionArr.count/3):(_collectionArr.count/3+1);
    if(_collectionArr.count%3==0){
        return 3;
    }else{
        if(section == (secnum-1)){
            return _collectionArr.count%3;
        }else
            return 3;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    yingyangCell *cell;
    if(cell==nil){
       cell =  (yingyangCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    }
    NSDictionary *dict = [_collectionArr objectAtIndex:(indexPath.section*3 + indexPath.item)];
    [cell.Img setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"picurl"]] ];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(85, 120);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2,10, 2,10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = {VIEW_WEIGHT,15};
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section==0){
      CGSize  size = {VIEW_WEIGHT,100};
        return size;
    }else{
        CGSize size = {VIEW_WEIGHT,20};
        return size;
    }
}



- ( UICollectionReusableView * ) collectionView : ( UICollectionView * ) collectionView viewForSupplementaryElementOfKind : ( NSString * ) kind atIndexPath : ( NSIndexPath * ) indexPath
{
    UICollectionReusableView * reusableview = nil ;
    if ( kind == UICollectionElementKindSectionHeader ) {
       UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier :@"Header" forIndexPath :indexPath ] ;
        reusableview = headerView;
    }
    
    if ( kind == UICollectionElementKindSectionFooter ) {
         myfooterView * footerview = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionFooter withReuseIdentifier : @"Footer" forIndexPath : indexPath ] ;
        reusableview = footerview;
    }
    return reusableview;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"*******%ld",(long)indexPath.item);
    SpDetailViewController *detailVC = [[SpDetailViewController alloc]init];
    detailVC.newsid = [[_collectionArr objectAtIndex:(indexPath.section*2+indexPath.item)] valueForKey:@"id"];
    detailVC.type = @"0";
    detailVC.imageurl = [[_collectionArr objectAtIndex:indexPath.row] valueForKey:@"picurl"];
    detailVC.title = @"营养详情";
    [self.navigationController pushViewController:detailVC animated:YES];

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchbar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchbar setShowsCancelButton:YES animated:YES];
}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
//{
//    if(searchbar.text.length==0){
//        [searchbar resignFirstResponder];
//    }
//}

//添加Cancel事件：
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"12345465");
    [searchbar resignFirstResponder];
    searchbar.text=@"";
    [searchbar resignFirstResponder];
    [searchbar setShowsCancelButton:NO animated:YES];
}
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchbar setShowsCancelButton:NO animated:YES];
    [searchbar resignFirstResponder];
    if(searchbar.text.length>0){
        [self loadListKey:searchbar.text];
    }
}

-(void)loadListKey:(NSString *)key
{
    NSString *urlstr = URL_SportSearchList(@"0",key);
    
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkWithUrlstr:urlstr];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"searchDataDict-----%@",dict);
        NSArray *arr =[dict valueForKey:@"result"];
        if(arr.count>0){
            _collectionArr = [NSArray arrayWithArray:arr];
            [collection reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未匹配配到结果" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
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
