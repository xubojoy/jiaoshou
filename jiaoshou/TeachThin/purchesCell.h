//
//  purchesCell.h
//  East Lake community
//
//  Created by 王园园 on 14-9-12.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface purchesCell : UITableViewCell

@property(nonatomic,strong)UIButton *selectBrn;

@property (retain, nonatomic) UIImageView *imgView;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *priceLabel;

@property (retain, nonatomic) UIButton *reduceBtn;
@property (retain, nonatomic) UIButton *addBtn;
@property (retain,nonatomic)UILabel *Numberlable;


@end
