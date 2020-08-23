
#import "XBSWeakProxy.h"

@implementation XBSWeakProxy
+ (instancetype)timerProxyWithTarget:(id)target{
    
    if (!target) return nil;
    
    XBSWeakProxy *proxy = [XBSWeakProxy alloc];
    proxy.target = target;
    
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
   return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}
@end
