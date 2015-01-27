//
//  ShopViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14/11/12.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopCell.h"
#import "ShopDetailViewController.h"
#import "CheckoutViewController.h"

@interface ShopViewController ()
#define PageSize 3
@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"食物配送";
        self.view.backgroundColor = [UIColor whiteColor];

        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
        self.navigationItem.leftBarButtonItem = backItem;
        
        GouwuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        GouwuBtn.frame = CGRectMake(0, 0, 24, 20);
        [GouwuBtn setImage:[UIImage imageNamed:@"nav_shopImg"] forState:UIControlStateNormal];
        [GouwuBtn addTarget:self action:@selector(RightClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:GouwuBtn];
    }
    return self;
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}



-(void)RightClick:(id)sender
{
    
    CheckoutViewController * COVC = [[CheckoutViewController alloc]init];
    [self.navigationController pushViewController:COVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self loadJudgeGouwuData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _listDict = [[NSMutableDictionary alloc]init];
    _OrderArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self setlayout];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
}


-(void)setlayout
{
    //实例化搜索栏
    
    _searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, WIDTH_VIEW(self.view), 40)];
    _searchbar.barStyle = UISearchBarStyleDefault;
    _searchbar.delegate = self;
    _searchbar.placeholder = @"请输入关键字";
    _searchbar.keyboardType = UIKeyboardAppearanceDefault;
    _searchbar.tintColor = [UIColor lightGrayColor];
    [self.view addSubview:_searchbar];
    

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,104,WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view)-104) collectionViewLayout:layout];
    collection.alwaysBounceVertical = YES;
    collection.backgroundColor = [UIColor clearColor];
    
    [collection registerClass:[ShopCell class]
   forCellWithReuseIdentifier:@"Cell"];
    collection.dataSource = self;
    collection.delegate = self;
    collection.scrollEnabled = YES;
    [collection reloadData];
    [self.view addSubview:collection];
    [self addHeader];
    [self addFooter];
    
    _currentTypeIndext = 1;
    _currentPage = 1;
    //[self loadSegData];
    [self SetMenuView];
    [self loadListDataWithtypeid:[NSString stringWithFormat:@"%ld",(long)_currentTypeIndext] page:_currentPage];
}

-(void)SetMenuView
{
    MenuView = [[ListMenuView alloc]initWithFrame:CGRectMake(-100,64, 120, self.view.frame.size.height-64)];
    [MenuView setUserInteractionEnabled:YES];
    MenuView.ListTable.backgroundColor = RGBACOLOR(247.,247., 249., 1);
    MenuView.selectCellColor = [UIColor whiteColor];
    MenuView.titleColor = [UIColor grayColor];
    MenuView.ListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MenuView];
    MenuView.tapColor = RGBACOLOR(92., 155., 54., 1);
    __weak ShopViewController *vc = self;
    [MenuView setTapActionBlock:^(NSInteger Index) {
        NSLog(@"Taped is:%ld",(long)Index);
        
        NSLog(@"&&&&&&&&&&&&&&&&%@",vc.listDict);
        
        NSString *typeid = [[vc.segDataArr objectAtIndex:Index] valueForKey:@"id"];
        vc.currentTypeIndext = [typeid integerValue];

        if(![[vc.listDict allKeys] containsObject:typeid]){//证明缓存中没有
            NSLog(@"000000000000000000000  %@",[vc.listDict allKeys]);
            vc.currentPage=1;
            [vc loadListDataWithtypeid:typeid page:1];
        }else{
            NSLog(@"111111111111111111111");
            vc.collectionArr = [[NSArray arrayWithArray:[vc.listDict valueForKey:typeid]] lastObject];
            NSArray *listArr = [[vc.listDict valueForKey:typeid] lastObject];
            vc.currentPage = [listArr count]%PageSize==0?[listArr count]/PageSize+1:[listArr count]/PageSize+2;
            [collection reloadData];
            _segDataArr = [[NSArray arrayWithArray:[vc.listDict valueForKey:typeid]] firstObject];
            [MenuView setListDataArr:_segDataArr];
        }
        
        
    }];
}

#pragma mark -
#pragma mark - Load
//-(void)loadSegData
//{
//    JSHttpRequest *request = [[JSHttpRequest alloc]init];
//    [request StartWorkPostWithurlstr:URL_FoodmenuType pragma:nil ImageData:nil];
//    NSLog(@"%@",URL_FoodmenuType);
//    request.successGetData = ^(id obj){
//        NSDictionary *dict = (NSDictionary *)obj;
//        NSLog(@"DataDict-----+++++++%@",dict);
//        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
//            //获取到分类列表的值
//            _segDataArr = [dict valueForKey:@"list"];
//            if(_segDataArr.count>0){
////                NSString *typeid = [[_segDataArr firstObject] valueForKey:@"id"];
////                _currentPage = 1;
////                [self loadListDataWithtypeid:typeid page:1];
//            }else{
//                [self InfoAlert:@"暂无任何分类数据" ok:@"知道了" cacel:nil];
//            }
//            [MenuView setListDataArr:_segDataArr];
//        }else{
//            [self InfoAlert:@"获取分类列表失败" ok:@"知道了" cacel:nil];
//        }
//    };
//    request.failureGetData = ^(void){
//        [self InfoAlert:@"请检查网络" ok:@"知道了" cacel:nil];
//    };
//}

-(void)loadListDataWithtypeid:(NSString *)typeid page:(NSInteger)page
{
    NSString *urlstr = URL_FoodMenuList;
    NSDictionary *prama = [NSDictionary dictionaryWithObjectsAndKeys:typeid,@"typeid",@(PageSize),@"pagesize",@(page),@"page", nil];
    NSLog(@"________________%@--%@",urlstr,prama);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:prama ImageData:nil];
    request.successGetData = ^(id obj){
        [MBHUDView dismissCurrentHUD];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)obj];
        NSLog(@"ListDataDict+++++++++++%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            NSArray *listArr = [dict valueForKey:@"list"];
           
            NSString *key = [NSString stringWithFormat:@"%ld",(long)_currentTypeIndext];
             NSLog(@"______________%@",key);
            NSMutableArray *temparr = [NSMutableArray arrayWithArray:[[_listDict valueForKey:key] lastObject]];//listDict id:[[segDataArr],[collectionDataArr]]
            if(listArr.count>0){
                if(page==1){
                    [temparr removeAllObjects];
                }
                [temparr addObjectsFromArray:listArr];
                _currentPage++;
            }else{
                
                [self InfoAlert:@"数据为空" ok:@"知道了" cacel:nil];
            }
            
            _collectionArr = [NSArray arrayWithArray:temparr];
            [collection reloadData];
            
            
            //侧边栏数据
            _segDataArr = [NSMutableArray arrayWithArray:[dict valueForKey:@"type"]];
            if(![[dict valueForKey:@"topid"] integerValue]==0){
                //不是第一级加返回
                NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"返回",@"name",[dict valueForKey:@"topid"],@"id",nil];
                [_segDataArr insertObject:d atIndex:0];
            }else{
                NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"全部",@"name",@"1",@"id",nil];
                [_segDataArr insertObject:d atIndex:0];
            }
            
            [MenuView setListDataArr:_segDataArr];
            //存储数据
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            if(_segDataArr.count>0||_collectionArr.count>0){
                [arr insertObject:_segDataArr atIndex:0];
                [arr insertObject:_collectionArr atIndex:1];
            }
            
            [_listDict setObject:arr forKey:key];
            
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
      
        [vc loadListDataWithtypeid:[NSString stringWithFormat:@"%ld",_currentTypeIndext] page:_currentPage];
        
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
   // NSString *typeid = [[self.segDataArr objectAtIndex:_currentTypeIndext] valueForKey:@"id"];
    [self loadListDataWithtypeid:[NSString stringWithFormat:@"%ld",_currentTypeIndext] page:_currentPage];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [collection reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}




#pragma  mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _collectionArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ShopCell * cell =  (ShopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dict = [_collectionArr objectAtIndex:indexPath.item];
    cell.cellimg.tag = 2000;
    [cell.cellimg setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"picurl"]]];
    cell.titlelabel.text = [dict valueForKey:@"title"];
    cell.oldprice.text =[NSString stringWithFormat:@" 原价:%@", [dict valueForKey:@"price"]];
    cell.newprice.text = [NSString stringWithFormat:@"优惠价:%@",[dict valueForKey:@"promotion"]];
    cell.gouwucheBtn.tag = indexPath.item;
    [cell.gouwucheBtn addTarget:self action:@selector(GouWuBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90,180);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10, 10,10);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopDetailViewController * sdvc = [[ShopDetailViewController alloc]init];
    sdvc.foodid = [[_collectionArr objectAtIndex:indexPath.item] valueForKey:@"id"];
    [self.navigationController pushViewController:sdvc animated:YES];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text length] == 0) {
		return;
	}else{
        [collection reloadData];
    }
}


#pragma Searcherbar Delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   [_searchbar resignFirstResponder];
    _searchbar.showsCancelButton = NO;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    if(searchBar.text.length>0){
        [self loadListKey:searchBar.text];
    }
}



-(void)loadListKey:(NSString *)key
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:key forKey:@"key"];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:URL_FoodMenuList pragma:dict ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"searchDataDict-----%@",dict);
        NSArray *arr =[dict valueForKey:@"list"];
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




-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchbar resignFirstResponder];
}

-(void)GouWuBtnPress:(UIButton *)btn
{
    NSLog(@"tap:%ld",(long)btn.tag);
    NSDictionary *dict = [_collectionArr objectAtIndex:btn.tag];
    NSString *foodid = [dict valueForKey:@"id"];
    [self PayChamgeAnimation:btn];
    [self loadGouwuData:foodid];
    
}

-(void)PayChamgeAnimation:(UIButton *)bt
{
    NSLog(@"_________%@",bt);
    //加入购物车动画效果
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    transitionLayer.contents = (id)bt.imageView.layer.contents;
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:bt.imageView.bounds fromView:bt.imageView];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:transitionLayer.position];
    CGPoint toPoint = CGPointMake(self.view.frame.size.width-40, 90);//30高度
    [movePath addQuadCurveToPoint:toPoint controlPoint:CGPointMake(self.view.frame.size.width,transitionLayer.position.y-90)];
    //关键帧
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = movePath.CGPath;
    positionAnimation.removedOnCompletion = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = 0.5;
    transitionLayer.opacity = 0.5;
    group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses= NO;
    
    [transitionLayer addAnimation:group forKey:@"opacity"];
     [self performSelector:@selector(addShopFinished:) withObject:transitionLayer afterDelay:0.5f];
}
- (void)addShopFinished:(CALayer*)transitionLayer
{
    transitionLayer.opacity = 0;
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
            //购物车加红点
            [GouwuBtn setImage:[UIImage imageNamed:@"nav_shopImg2"] forState:UIControlStateNormal];
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


-(void)loadJudgeGouwuData
{
    NSString *uid = [ManageVC sharedManage].uid;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:URL_JudgeHouwuche pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"searchDataDict-----%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            NSInteger result = [[dict valueForKey:@"result"] integerValue];
            if(result==0){//购物车中不存在东西
                [GouwuBtn setImage:[UIImage imageNamed:@"nav_shopImg"] forState:UIControlStateNormal];
            }else{//购物车中有东西
                //购物车加红点
                [GouwuBtn setImage:[UIImage imageNamed:@"nav_shopImg2"] forState:UIControlStateNormal];
            }
        }else{
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
