//
//  FoodData.h
//  TeachThin
//
//  Created by 王园园 on 14-12-29.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodData : NSObject


+(FoodData *)sharedfoodData;

@property(nonatomic,copy)NSString *DPversion;
@property(nonatomic,copy)NSString *CPversion;

-(void)setDPDataArr:(NSArray *)arr;
-(NSArray *)readDPDataArr;

-(void)setCPDataArr:(NSArray *)arr;
-(NSArray *)readCPDataArr;

@end
