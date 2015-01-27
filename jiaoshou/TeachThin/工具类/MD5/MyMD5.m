//
//  MyMD5.m
//  TeachThin
//
//  Created by myStyle on 14-12-22.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "MyMD5.h"

@implementation MyMD5

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end
