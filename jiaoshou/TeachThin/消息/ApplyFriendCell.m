//
//  TestTableViewCell.m
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-10.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ApplyFriendCell.h"

@implementation ApplyFriendCell
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
          delegate:(id<WKTableViewCellDelegate>)delegate
       inTableView:(UITableView *)tableView
withRightButtonTitles:(NSArray *)rightButtonTitles{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier delegate:delegate inTableView:tableView withRightButtonTitles:rightButtonTitles];
    if (self){
//        _contentLabel=[[UILabel alloc]initWithFrame:self.bounds];
//        _contentLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight;
//        //_contentLabel.backgroundColor=[UIColor grayColor];
//        [self.cellContentView addSubview:_contentLabel];
        
        
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        self.userImageView.backgroundColor = [UIColor clearColor];
        self.userImageView.image = [UIImage imageNamed:@"add_new_friend"];
        CALayer *layer = self.userImageView.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:self.userImageView.frame.size.width/2];
        [self.cellContentView addSubview:self.userImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 150, 25 )];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.text = @"新朋友";
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.cellContentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 250, 25 )];
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        [self.cellContentView addSubview:self.contentLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(70, 60, VIEW_WEIGHT-70, 0.5)];
        self.lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        [self.cellContentView addSubview:self.lineView];
    }
    return self;
}

-(void)renderApplyCellWithDic:(NSDictionary *)dic{

    NSLog(@">>>>>>>>好友申请的渲染数据：%@",dic);
    self.nameLabel.text = [dic valueForKey:@"realname"];
    self.contentLabel.text = [NSString stringWithFormat:@"%@请求加你为好友",self.nameLabel.text];


}

@end
