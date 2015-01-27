//
//  KeshisegView.m
//  TeachThin
//
//  Created by 王园园 on 14-12-31.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "KeshisegView.h"
#import "Macro.h"

@implementation KeshisegView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setlayOut];
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setlayOut
{
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame = CGRectMake(0, 0, self.frame.size.width/2, 40);
    [_btn1 setTitle:@"科室" forState:UIControlStateNormal];
    _btn1.tag = 1000;
    [_btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btn1 setTitleColor:RGBACOLOR(49., 140., 9., 1) forState:UIControlStateSelected];
    [_btn1 setImage:[UIImage imageNamed:@"grayArow"] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageNamed:@"greenArow"] forState:UIControlStateSelected];
    [_btn1 setImageEdgeInsets:UIEdgeInsetsMake(7.0, VIEW_WEIGHT/2-40, 5.0, 0.0)];
    _btn1.titleLabel.font = [UIFont boldSystemFontOfSize:17.];
    [_btn1 addTarget:self action:@selector(BtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btn1];
    
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 40);
    [_btn2 setTitle:@"满意度" forState:UIControlStateNormal];
    [_btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btn2 setTitleColor:RGBACOLOR(49., 140., 9., 1) forState:UIControlStateSelected];
    [_btn2 setImage:[UIImage imageNamed:@"grayArow"] forState:UIControlStateNormal];
    [_btn2 setImage:[UIImage imageNamed:@"greenArow"] forState:UIControlStateSelected];
    [_btn2 setImageEdgeInsets:UIEdgeInsetsMake(7.0, VIEW_WEIGHT/2-40, 5.0, 0.0)];
    _btn2.titleLabel.font = [UIFont boldSystemFontOfSize:17.];
    _btn2.tag = 2000;
    [_btn2 addTarget:self action:@selector(BtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btn2];
    
    UIImageView *longLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT_VIEW(_topView)-0.5, self.frame.size.width, 0.5)];
    longLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:longLine];
    
    UIImageView *shorLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-0.5, 5, 1,30)];
    shorLine.backgroundColor = RGBACOLOR(202., 202., 202., 1);
    [self addSubview:shorLine];
    _btn1.selected = YES;
}

-(void)setCotentWithItems:(NSArray *)items;
{
    //items =  @[@{@"id": @"0",@"name": @"全部"},@{@"id": @"1",@"name": @"美容科"}];
    _cotentView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, VIEW_WEIGHT, 200)];
    _cotentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cotentView];
 
    NSInteger row = (items.count%4==0)?(items.count/4):(items.count/4+1);
    int index = 0;
    for(int i=0;i<row;i++){
        for(int j=0;j<4;j++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(VIEW_WEIGHT/4*j, 40*i, VIEW_WEIGHT/4, 40) ;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.];
            btn.tag = index;
            [btn addTarget:self action:@selector(ItemBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[[items objectAtIndex:index] valueForKey:@"name"] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 0.5;
            [_cotentView addSubview:btn];
            index++;
            if(index==items.count){
                return;
            }
            
        }
    }
}


-(void)BtnTap:(UIButton *)btn
{
    if(btn == _btn1){
        if(_btn2.selected==NO&&self.frame.size.height>40){
            [UIView animateWithDuration:0.1 animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, VIEW_WEIGHT, 40);
            } completion:^(BOOL finished) {
            }];
        }else if(_btn2.selected==YES){
            _btn1.selected = YES;
            _btn2.selected = NO;
            if(_SegBtntap){
                _SegBtntap(btn.tag);//1000是科室
            }
        }else{
            _btn1.selected = YES;
            _btn2.selected = NO;
            [UIView animateWithDuration:0.1 animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, VIEW_WEIGHT, VIEW_HEIGHT-self.frame.origin.y);
            } completion:^(BOOL finished) {
            }];
        }
    }else{
        _btn2.selected = YES;
        _btn1.selected = NO;
        [UIView animateWithDuration:0.1 animations:^{
           self.frame = CGRectMake(0, self.frame.origin.y, VIEW_WEIGHT, 40);
        } completion:^(BOOL finished) {
            if(_SegBtntap){
                _SegBtntap(btn.tag);//2000是满意度
            }
        }];
    }
}

-(void)selectedIndex:(NSInteger)index;
{
    if(index==0){
        [self BtnTap:_btn1];
    }else{
        [self BtnTap:_btn2];
    }
}
-(void)ItemBtnPress:(UIButton *)btn
{
    if(btn.tag==0){
        [_btn1 setTitle:@"科室" forState:UIControlStateNormal];
    }else{
        [_btn1 setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, VIEW_WEIGHT, 40);
    } completion:^(BOOL finished) {
        if(_SegBtntap){
            _SegBtntap(btn.tag);
        }
    }];
}

@end
