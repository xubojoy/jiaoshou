//
//  Message.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    // 1、设置时间 时间戳转化为时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"adddate"] longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //////////////////////
    NSString *time = [formatter stringFromDate:date];
    
    self.time = time;
    self.content = dict[@"content"];
    self.type = [dict[@"type"] intValue];
    if(self.type==0){
        self.icon = dict[@"upic"];
    }else{
        self.icon = dict[@"epic"];
    }
}



@end
