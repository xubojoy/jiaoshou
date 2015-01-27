//
//  FoodData.m
//  TeachThin
//
//  Created by 王园园 on 14-12-29.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "FoodData.h"
static FoodData * foodData;

@implementation FoodData

+(FoodData *)sharedfoodData;
{
    if (foodData==nil) {
        foodData = [[FoodData alloc] init];
        if(![[NSUserDefaults standardUserDefaults]valueForKey:@"CPFoodversion"]){
            
            foodData.CPversion = @"0";
        }else{
            foodData.CPversion = [[NSUserDefaults standardUserDefaults]valueForKey:@"CPFoodversion"];
        }
        
        if(![[NSUserDefaults standardUserDefaults]valueForKey:@"DPFoodversion"]){
            foodData.DPversion = @"0";
        }else{
            foodData.DPversion = [[NSUserDefaults standardUserDefaults]valueForKey:@"DPFoodversion"];
        }
        NSLog(@"_____%@",foodData.DPversion);
        
    }
    return foodData;
}

-(void)setDPDataArr:(NSArray *)arr;
{
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"FoodDPData"];
}

-(NSArray *)readDPDataArr;
{
    NSArray * arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"FoodDPData"];
    return arr;
}



-(void)setCPDataArr:(NSArray *)arr;
{
    
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"FoodCPData"];
}
-(NSArray *)readCPDataArr;
{
     NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"FoodCPData"];
    return arr;
}
@end
