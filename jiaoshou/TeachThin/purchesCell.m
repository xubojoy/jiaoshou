//
//  purchesCell.m
//  East Lake community
//
//  Created by 王园园 on 14-9-12.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import "purchesCell.h"

@implementation purchesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectBrn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBrn.frame = CGRectMake(0,15,40,40);
        [_selectBrn setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        [_selectBrn setImage:[UIImage imageNamed:@"foodunselect"] forState:UIControlStateNormal];
        [_selectBrn setImage:[UIImage imageNamed:@"foodselect"] forState:UIControlStateSelected];
        [self addSubview:_selectBrn];

        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(35,10,50,50)];
        _imgView.layer.cornerRadius = 5.;
        [self addSubview:_imgView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+10, 10, 220, 20)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        [self addSubview:_nameLabel];
        
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+10,CGRectGetMaxY(_nameLabel.frame)+5, 60, 20)];
        _priceLabel.textColor = RGBACOLOR(169., 169., 169., 1);
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
        [self addSubview:_priceLabel];
        
        int y=25;
        
        UIView *subview = [[UIView alloc]initWithFrame:CGRectMake(222, y, 85, 25)];
        subview.layer.borderColor = [UIColor lightGrayColor].CGColor;
        subview.layer.borderWidth = 0.8;
        subview.layer.cornerRadius = 3.;
        [self addSubview:subview];
        
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBtn.frame = CGRectMake(215,y-5,35,35);
        [_reduceBtn setTitle:@"  -" forState:UIControlStateNormal];
        [_reduceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _reduceBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_reduceBtn];
        
        _Numberlable = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(_reduceBtn),y-0.2, 30, 25)];
        _Numberlable.textColor = [UIColor blackColor];
        _Numberlable.backgroundColor = [UIColor clearColor];
        _Numberlable.textAlignment = NSTextAlignmentCenter;
        _Numberlable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        _Numberlable.tag = 1000;
        _Numberlable.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _Numberlable.layer.borderWidth = 0.5;
        [self addSubview:_Numberlable];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(VIEW_MAXX(_Numberlable),y-5,35,35);
        _addBtn.backgroundColor = [UIColor clearColor];
        [_addBtn setTitle:@"+  " forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:_addBtn];
        
        
    
        UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_MAXY(_imgView)+10, WIDTH_VIEW(self), 0.7)];
        linelabel.backgroundColor = RGBACOLOR(204., 204., 204., 1);
        [self addSubview:linelabel];
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
