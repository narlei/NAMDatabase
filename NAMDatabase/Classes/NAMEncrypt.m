//
//  NAMEncrypt.m
//  NAMLibrary
//
//  Created by Narlei A Moreira on 7/27/16.
//  Copyright © 2016 Narlei A Moreira. All rights reserved.
//

#import "NAMEncrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NAMEncrypt

+ (NSString *)sha256:(NSString *)string {
    const char *cString = [string UTF8String];
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cString, (int)strlen(cString), digest);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return [hash lowercaseString];
}

@end
