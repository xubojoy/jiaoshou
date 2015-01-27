//
//  ShopCell.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-14.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "ShopCell.h"

@implementation ShopCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cellimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        _cellimg.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_cellimg];
        
        _titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_MAXY(_cellimg), 90, 22)];
        _titlelabel.textAlignment = NSTextAlignmentLeft;
        _titlelabel.font =[UIFont systemFontOfSize:14.0];
        _titlelabel.textColor = [UIColor blackColor];
        [self addSubview:_titlelabel];
    
        
        _oldprice = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_MAXY(_titlelabel), 90, 18)];
        _oldprice.textColor = [UIColor grayColor];
        _oldprice.font = [UIFont systemFontOfSize:12.0];
        _oldprice.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_oldprice];
        
        _newprice = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_MAXY(_oldprice), 90, 18)];
        _newprice.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _newprice.textAlignment = NSTextAlignmentLeft;
        _newprice.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_newprice];
        
        _gouwucheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gouwucheBtn.frame = CGRectMake(45-26, VIEW_MAXY(_newprice)+2, 53, 21);
        //[_gouwucheBtn setImage:[UIImage imageNamed:@"shop1"] forState:UIControlStateSelected];
        [_gouwucheBtn setImage:[UIImage imageNamed:@"shop2"] forState:UIControlStateNormal];
        [self addSubview:_gouwucheBtn];
    }
    return self;
}




@end
