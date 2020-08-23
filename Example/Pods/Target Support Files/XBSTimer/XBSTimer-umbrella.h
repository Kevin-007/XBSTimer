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

#import "CADisplayLink+XBSDisplayLink.h"
#import "NSTimer+XBSTimer.h"
#import "XBSGCDTimer.h"
#import "XBSTimer.h"
#import "XBSWeakProxy.h"

FOUNDATION_EXPORT double XBSTimerVersionNumber;
FOUNDATION_EXPORT const unsigned char XBSTimerVersionString[];

