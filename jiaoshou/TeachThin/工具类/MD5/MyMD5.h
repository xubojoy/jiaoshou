//
//  MyMD5.h
//  TeachThin
//
//  Created by myStyle on 14-12-22.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface MyMD5 : NSObject
+ (NSString *)md5HexDigest:(NSString*)input;
@end
