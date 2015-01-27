//
//  YingyangViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-11-24.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yingyangCell.h"
#import "ListMenuView.h"
#import "UIImageView+AFNetworking.h"
#import "myfooterView.h"
#import "MJRefresh.h"

@interface YingyangViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UICollectionViewDelegate>
{
    UICollectionView *collection;
    ListMenuView *MenuView;

    UISearchBar *searchbar;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    MJRefreshHeaderView *freshHeader;
    MJRefreshFooterView *freshFooter;
}

@property(nonatomic,strong)NSArray *segDataArr;
@property(nonatomic,retain)NSMutableDictionary *listDict;
@property(nonatomic,retain)NSArray *collectionArr;


@property NSInteger currentTypeIndext;
@property NSInteger currentPage;
@end
