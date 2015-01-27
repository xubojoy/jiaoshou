//
//  MyCheckViewController.h
//  TeachThin
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetViewDelegate>
{
    UITableView *table;
    UILabel *infoLable;
}

@property(nonatomic,retain)NSDictionary *Dict;
@property(nonatomic,retain)NSArray *dataArr;
@end
