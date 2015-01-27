//
//  SportsViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-11-19.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListMenuView.h"
#import "JSHttpRequest.h"
#import "SportCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "MJRefresh.h"


@interface SportsViewController :UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    UIButton *homeBtn;
    ListMenuView *MenuView;
    MJRefreshHeaderView *freshHeader;
    MJRefreshFooterView *freshFooter;
}
@property NSString *labelString;

@property(nonatomic,strong)NSArray *segDataArr;
@property(nonatomic,retain)NSMutableDictionary *listDict;
@property(nonatomic,retain)NSArray *tableArr;


@property NSInteger currentTypeIndext;

@property NSInteger currentPage;

@end
