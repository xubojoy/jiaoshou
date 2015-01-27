//
//  specailCell.m
//  TeachThin
//
//  Created by 王园园 on 14-12-31.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "specailCell.h"

@implementation specailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
        _imgView.backgroundColor = [UIColor yellowColor];
        _imgView.layer.cornerRadius = 25.0f;
        _imgView.layer.masksToBounds = YES;
        [self addSubview:_imgView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(_imgView)+15, 5, VIEW_WEIGHT-80, 25)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        [self addSubview:_nameLabel];

        _cotentLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(_imgView)+15,30, VIEW_WEIGHT-80, 50)];
        _cotentLabel.backgroundColor = [UIColor clearColor];
        _cotentLabel.textColor = [UIColor grayColor];
        _cotentLabel.tag = 100;
        _cotentLabel.numberOfLines = 2;
        _cotentLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        [self addSubview:_cotentLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
