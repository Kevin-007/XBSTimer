
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^XBSDisplayLinkCallbackBlock)(CADisplayLink *link);

@interface CADisplayLink (XBSDisplayLink)
/** 同系统方法，仅解决循环引用问题*/
+ (CADisplayLink *)xb_displayLinkWithTarget:(id)target selector:(SEL)sel;

/** 同系统方法，自动添加到当前runloop中，Mode: NSRunLoopCommonModes*/
+ (CADisplayLink *)xb_scheduledDisplayLinkWithTarget:(id)target selector:(SEL)sel;

/** Block callback，auto run, runloop mode: NSRunLoopCommonModes*/
+ (CADisplayLink *)xb_scheduledDisplayLinkWithBlock:(XBSDisplayLinkCallbackBlock)block;
@end

NS_ASSUME_NONNULL_END
