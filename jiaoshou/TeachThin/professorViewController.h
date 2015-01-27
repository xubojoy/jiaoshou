//
//  professorViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-12-15.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KeshisegView.h"
#import "Macro.h"
#import "MJRefresh.h"
#import "specailCell.h"
#import "ProdetailViewController.h"

@interface professorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetViewDelegate>
{
    UITableView *table;
    MJRefreshHeaderView *freshHeader;
    MJRefreshFooterView *freshFooter;
}

@property(nonatomic,retain)KeshisegView *keshiSeg;
@property(nonatomic,retain)NSMutableArray *keshiListArr;//科室分类列表


@property(nonatomic,retain)NSMutableDictionary *KeProfessorDict;//科室专家列表
@property NSInteger currentKeshi;
@property NSInteger kePage;
@property(nonatomic,retain)NSMutableArray *StarProfessorArr;//满意度排名专家列表
@property NSInteger starPage;
@property(nonatomic,retain)NSArray *tableArr;

@end
