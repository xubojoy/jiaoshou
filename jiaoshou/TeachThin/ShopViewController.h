//
//  ShopViewController.h
//  TeachThin
//
//  Created by 巩鑫 on 14/11/12.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListMenuView.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
@interface ShopViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
{
    UICollectionView * collection;
    ListMenuView *MenuView;
    UIButton *GouwuBtn;
    MJRefreshHeaderView *freshHeader;
    MJRefreshFooterView *freshFooter;
}
@property(nonatomic,strong)UISearchBar * searchbar;

@property(nonatomic,strong)NSMutableArray *segDataArr;
@property(nonatomic,retain)NSMutableDictionary *listDict;
@property(nonatomic,retain)NSArray *collectionArr;


@property NSInteger currentTypeIndext;
@property NSInteger currentPage;

@property(nonatomic,retain)NSMutableArray *OrderArr;

@end
