//
//  CommentView.h
//  TeachThin
//
//  Created by 王园园 on 15-1-5.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHttpRequest.h"

@interface CommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *RecordArr;
@property(nonatomic,strong)NSArray *commentArr;
@property(nonatomic,strong)NSString *expid;

-(void)setCommentData:(NSArray *)Arr WithexpId:(NSString *)userid;
@end
