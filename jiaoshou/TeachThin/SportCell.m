//
//  SportCell.m
//  TeachThin
//
//  Created by 王园园 on 15-1-6.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import "SportCell.h"

@implementation SportCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _img.layer.cornerRadius = 5.;
        [self addSubview:_img];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(_img)+10, 15, VIEW_WEIGHT-90, 20)];
        _titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self addSubview:_titleLable];
        
        _detaillable = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(_img)+10, VIEW_MAXY(_titleLable)+7, VIEW_WEIGHT-90, 30)];
        _detaillable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        _detaillable.backgroundColor = [UIColor clearColor];
        _detaillable.textColor =[[UIColor grayColor] colorWithAlphaComponent:0.8];
        [self addSubview:_detaillable];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
