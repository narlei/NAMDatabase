#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NAMDatabase.h"
#import "NAMEncrypt.h"
#import "NAMObjectModel.h"

FOUNDATION_EXPORT double NAMDatabaseVersionNumber;
FOUNDATION_EXPORT const unsigned char NAMDatabaseVersionString[];

