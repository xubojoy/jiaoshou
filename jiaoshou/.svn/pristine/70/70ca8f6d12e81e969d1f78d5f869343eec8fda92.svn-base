//
//  familyCell.m
//  TeachThin
//
//  Created by 王园园 on 14-11-21.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "familyCell.h"

@implementation familyCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"familyCell" owner:self options:nil] objectAtIndex:0];
        self.userImg.image = [UIImage imageNamed:@"chatListCellHead.png"];
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
        [self.userImg.layer setMasksToBounds:YES];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(70, 60-0.5, VIEW_WEIGHT-70, 0.5)];
        self.lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        [self.contentView addSubview:self.lineView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BtnPress:)];
        _View1.tag=0;
        [_View1 addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BtnPress:)];
        _View2.tag=1;
        [_View2 addGestureRecognizer:tap2];
        
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BtnPress:)];
        _View3.tag = 2;
        [_View3 addGestureRecognizer:tap3];
        
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BtnPress:)];
        _View4.tag = 3;
        [_View4 addGestureRecognizer:tap4];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
}

-(void)BtnPress:(UITapGestureRecognizer *)gesture
{
    if(_BtntapMethed){
        self.BtntapMethed(gesture.view.tag);
    }
}
-(void)renderFriendWithBuddyInfo:(EMBuddy *)buddy{
    self.phoneLable.text = [NSString stringWithFormat:@"手机号：%@",buddy.username];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
