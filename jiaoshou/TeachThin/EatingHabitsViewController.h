//
//  EatingHabitsViewController.h
//  TeachThin
//
//  Created by 巩鑫 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXSelectBtn.h"
@interface EatingHabitsViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,NetViewDelegate>
{
    UITableView * table;
    UIBarButtonItem * sureBtn;
    GXSelectBtn * selectBtn;
    
}
@property(nonatomic,strong)NSArray * arr;
@property(nonatomic,strong)NSMutableArray * postArr;
@end
