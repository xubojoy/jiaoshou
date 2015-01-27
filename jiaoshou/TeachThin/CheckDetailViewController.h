//
//  CheckDetailViewController.h
//  TeachThin
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CheckDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    
    UIButton *openBtn;
}

@property(nonatomic,retain)NSDictionary *DataDict;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *sex;
@property(nonatomic,retain)NSString *age;
@property(nonatomic,retain)NSString *nation;
@property(nonatomic,retain)NSString *professor;
@end
