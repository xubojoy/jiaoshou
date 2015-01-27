//
//  CustomActionSheet.h
//  LZWCustomActionSheet
//
//  Created by hbh  on 14-9-26.
//  Copyright (c) 2014年 lizhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Datetime.h"

@interface LZWCustomActionSheet : UIView
{
    UIToolbar* toolBar;
    NSArray * dayArray;
    
    int strMonth;
    int strYear;
    bool timePacker;
    
    NSString *selectTime;
    UILabel *calendarTitleLabel;
}


-(id)initWithView:(UIView *)view AndHeight:(float)height;

-(void)showInView:(UIView *)view;
@property(nonatomic,retain)UIView *CalenderView;
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property(nonatomic,strong)void(^SureBtnPress)(NSString *);

@end
