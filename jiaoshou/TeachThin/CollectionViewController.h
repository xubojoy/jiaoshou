//
//  CollectionViewController.h
//  TeachThin
//
//  Created by 巩鑫 on 14-11-19.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportCell.h"
#import "SpDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"

@interface CollectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetViewDelegate>
{
    UITableView *table;
    UILabel *infoLable;
    MJRefreshHeaderView *freshHeader;
    MJRefreshFooterView *freshFooter;
}

@property(nonatomic,retain)NSString *uid;
@property(nonatomic,strong)NSMutableArray *ListArr;
@property NSInteger currentPage;

@end
