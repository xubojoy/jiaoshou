//
//  HealthFileViewController.h
//  TeachThin
//
//  Created by 巩鑫 on 14-11-14.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "FSLineChart.h"
#import "LZWCustomActionSheet.h"

@interface HealthFileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetViewDelegate,ASValueTrackingSliderDataSource>
{
    UITableView * table;
    UIView *header;
    UIButton *dateBtn;
    UIView *cell1View;
    UIView *cell2View;
    FSLineChart* lineChart;
}

@property(nonatomic,retain)NSString *uid;

@property(nonatomic,retain) ASValueTrackingSlider *slider;
@property(nonatomic,retain) ASValueTrackingSlider *slider2;

@property float weightValue;
@property float BMIValue;
@property(nonatomic,strong)NSString *Currentdate;

@property(nonatomic,retain)NSMutableArray *dateArr;
@property(nonatomic,retain)NSMutableArray *WeightDataArr;

@end
