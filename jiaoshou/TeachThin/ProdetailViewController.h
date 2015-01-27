//
//  ProdetailViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-12-31.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "specailCell.h"
#import "CommentView.h"
#import "ManageVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProdetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    CommentView *commentView;
    UILabel *infolable;
}


@property(nonatomic,strong)NSDictionary *ProfessorDict;//传值
@property(nonatomic,strong)NSDictionary *InfoData;
@property(nonatomic,strong)NSDictionary *personDict;
@property(nonatomic,strong)NSArray *commentArr;

@end
