
#import "NSTimer+XBSTimer.h"
#import "XBSWeakProxy.h"

#import <objc/runtime.h>

@implementation NSTimer (XBSTimer)

#pragma mark - Public
+ (NSTimer *)xb_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo{
    
    return [self timerWithTimeInterval:ti target:[XBSWeakProxy timerProxyWithTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)xb_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo{
    
    return [self scheduledTimerWithTimeInterval:ti target:[XBSWeakProxy timerProxyWithTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)xb_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(nonnull XBSTimerCallbackBlock)block{
    if (!block) return nil;
    
    NSTimer *timer = [self timerWithTimeInterval:interval   target:[XBSWeakProxy timerProxyWithTarget:self] selector:@selector(_blockAction:) userInfo:nil repeats:repeats];
    
    if (!timer) return timer;
    
    objc_setAssociatedObject(timer, @selector(_blockAction:), block, OBJC_ASSOCIATION_COPY);
    
    return timer;
}


+ (NSTimer *)xb_scheduledTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(nonnull XBSTimerCallbackBlock)block{
    if (!block) return nil;
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval   target:[XBSWeakProxy timerProxyWithTarget:self] selector:@selector(_blockAction:) userInfo:nil repeats:repeats];
    
    if (!timer) return timer;
    
    objc_setAssociatedObject(timer, @selector(_blockAction:), block, OBJC_ASSOCIATION_COPY);
    
    return timer;
}

#pragma mark - Privite
+ (void)_blockAction:(NSTimer *)timer{
    XBSTimerCallbackBlock block = objc_getAssociatedObject(timer, _cmd);
    
    !block?:block(timer);
}
@end

