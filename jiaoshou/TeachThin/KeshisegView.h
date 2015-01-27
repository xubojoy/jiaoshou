//
//  KeshisegView.h
//  TeachThin
//
//  Created by 王园园 on 14-12-31.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeshisegView : UIView

-(void)setCotentWithItems:(NSArray *)items;
-(void)selectedIndex:(NSInteger)index;

@property(nonatomic,strong)UIButton *btn1;
@property(nonatomic,strong)UIButton *btn2;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *cotentView;

@property(nonatomic,strong) void (^SegBtntap)(NSInteger);
@end
