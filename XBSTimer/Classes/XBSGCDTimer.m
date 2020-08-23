
#import "XBSGCDTimer.h"

#import "XBSWeakProxy.h"

#import <objc/runtime.h>

@implementation XBSGCDTimer

#pragma mark - Public
+ (XBSGCDTimer *)xb_GCDTimerWithSartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue repeats:(BOOL)repeats block:(XBSGCDTimerCallbackBlock)block{
    
    if (!block || start < 0 || (interval <= 0 && repeats)) return nil;
    
    XBSGCDTimer *gcdTimer = [[XBSGCDTimer alloc] init];
    
    // queue
    dispatch_queue_t queue_t = queue ?: dispatch_get_main_queue();
    
    // create
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue_t);
    
    // set time
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC, 0);
    
    
    objc_setAssociatedObject(gcdTimer, @selector(fire), timer, OBJC_ASSOCIATION_RETAIN);
    
    // callback
    dispatch_source_set_event_handler(timer, ^{
        block(gcdTimer);
        if (!repeats) { // no repeats
            [gcdTimer invalidate];
        }
    });
    
    
    return gcdTimer;
}

+ (XBSGCDTimer *)xb_scheduledGCDTimerWithSartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue repeats:(BOOL)repeats block:(XBSGCDTimerCallbackBlock)block{
    
    XBSGCDTimer *gcdTimer = [self xb_GCDTimerWithSartTime:start interval:interval queue:queue repeats:repeats block:block];
    
    [gcdTimer fire];
    
    return gcdTimer;
}

+ (XBSGCDTimer *)xb_GCDTimerWithTarget:(id)target selector:(SEL)selector SartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue repeats:(BOOL)repeats{
    
    XBSWeakProxy *proxy = [XBSWeakProxy timerProxyWithTarget:target];
    
    return [self xb_GCDTimerWithSartTime:start interval:interval queue:queue repeats:repeats block:^(XBSGCDTimer * _Nonnull timer) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [proxy performSelector:selector];
        #pragma clang diagnostic pop
    }];
}

+ (XBSGCDTimer *)xb_scheduledGCDTimerWithTarget:(id)target selector:(SEL)selector SartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue repeats:(BOOL)repeats{
    
    XBSWeakProxy *proxy = [XBSWeakProxy timerProxyWithTarget:target];
    
    XBSGCDTimer * gcdTimer = [self xb_GCDTimerWithSartTime:start interval:interval queue:queue repeats:repeats block:^(XBSGCDTimer * _Nonnull timer) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [proxy performSelector:selector];
        #pragma clang diagnostic pop
    }];
    
    [gcdTimer fire];
    
    return gcdTimer;
}

/** start*/
- (void)fire{
   
    dispatch_source_t timer = objc_getAssociatedObject(self, _cmd);
    
    if (timer) dispatch_resume(timer);
}

/** stop*/
- (void)invalidate{
    
    dispatch_source_t timer = objc_getAssociatedObject(self, @selector(fire));
    
    if (timer) dispatch_source_cancel(timer);
    
    objc_removeAssociatedObjects(self);
}

@end
