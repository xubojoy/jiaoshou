//
//  TestTableViewCell.h
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-10.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKTableViewCell.h"

@interface ApplyFriendCell : WKTableViewCell{
    
}
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIView *lineView;
-(void)renderApplyCellWithDic:(NSDictionary *)dic;
@end
