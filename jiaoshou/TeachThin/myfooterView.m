//
//  myfooterView.m
//  TeachThin
//
//  Created by 王园园 on 15-1-7.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import "myfooterView.h"

@implementation myfooterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, VIEW_WEIGHT-10, 10)];
        _img.image = [UIImage imageNamed:@"shujia"];
        [self addSubview:_img];
    }
    return self;
}

@end
