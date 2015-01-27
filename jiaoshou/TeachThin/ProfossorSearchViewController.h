//
//  ProfossorSearchViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-12-15.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "specailCell.h"
#import "ProdetailViewController.h"

@interface ProfossorSearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
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
