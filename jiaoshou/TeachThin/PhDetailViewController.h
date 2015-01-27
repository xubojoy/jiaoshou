//
//  PhDetailViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodData.h"

@interface PhDetailViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate, UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *imgView;
    //UITextField *nameTextField;
    UISearchBar *nametextBar;
    UITableView *table;
}

@property(nonatomic,strong)UIImage *TakeImg;
@property NSInteger foodType;

@property(nonatomic,strong)NSArray *tableFoodData;

@property(nonatomic,strong)NSMutableArray *tablearr;

@end
