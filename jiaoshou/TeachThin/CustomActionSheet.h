//
//  CustomActionSheet.h
//  TeachThin
//
//  Created by 巩鑫 on 14-11-14.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActionSheet : UIView
{
    UIToolbar* toolBar;
   
}

-(id)initWithView:(UIView *)view AndHeight:(float)height;

-(void)showInView:(UIView *)view;
@property(nonatomic,retain)UIView *CalenderView;
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property(nonatomic,strong)void(^SureBtnPress)();

@end
