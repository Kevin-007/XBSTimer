
#import "CADisplayLink+XBSDisplayLink.h"

#import "XBSWeakProxy.h"

#import <objc/runtime.h>

@implementation CADisplayLink (XBSDisplayLink)
#pragma mark - Public
+ (CADisplayLink *)xb_displayLinkWithTarget:(id)target selector:(SEL)sel{
    
    return [self displayLinkWithTarget:[XBSWeakProxy timerProxyWithTarget:target] selector:sel];
}

+ (CADisplayLink *)xb_scheduledDisplayLinkWithTarget:(id)target selector:(SEL)sel{
    
    CADisplayLink *link = [self displayLinkWithTarget:[XBSWeakProxy timerProxyWithTarget:target] selector:sel];
    
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    return link;
    
}

+ (CADisplayLink *)xb_scheduledDisplayLinkWithBlock:(XBSDisplayLinkCallbackBlock)block{
    if (!block) return nil;
    CADisplayLink *link = [self xb_displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    
    objc_setAssociatedObject(link, @selector(displayLinkAction:), block, OBJC_ASSOCIATION_COPY);
    
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    return link;
}

#pragma mark - Privite
+ (void)displayLinkAction:(CADisplayLink *)link{
   
    XBSDisplayLinkCallbackBlock block = objc_getAssociatedObject(link, _cmd);
    !block?:block(link);
}
@end
