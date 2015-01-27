//
//  SpSearchViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SpDetailViewController.h"
#import "SportCell.h"

@interface SpSearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *mySearchBar;
    UITableView *searchtableView;
    UIView *_viewBlackCover;
    
    
    UITableView *Datatable;
}

- (void)setRecentKeyword:(NSArray *)arrRecentKeyword;
- (void)setKeyword:(NSString *)strKeyword;
@property BOOL bIsWorking ;
@property (nonatomic, readonly) NSArray *arrRecent;

@property(nonatomic,retain)NSArray *tableArr;

@end
