//
//  CheckoutViewController.h
//  TeachThin
//
//  Created by 巩鑫 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXSelectBtn.h"
#import "purchesCell.h"
@interface CheckoutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetViewDelegate>
{
    UITableView * table;
    UIView * footer;
    UIButton * sureBtn;
    UILabel * Allprice;
    
    UILabel *infoLable;
}
@property float foodprice;
@property(nonatomic,strong)NSArray * DataArr;

@property(nonatomic,strong)NSMutableDictionary * selectDict;
@property(nonatomic,retain)NSMutableArray *selectrowArr;

@end
