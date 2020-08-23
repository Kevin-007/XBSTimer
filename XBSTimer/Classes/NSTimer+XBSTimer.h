

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^XBSTimerCallbackBlock)(NSTimer *timer);

@interface NSTimer (XBSTimer)
/** 方法一，与系统同名方法一致， 需要手动添加到runloop中，自己控制启动*/
+ (NSTimer *)xb_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

/** 方法二， 与系统同名方法一致，系统自动添加到runloop中，创建成功自动启动*/
+ (NSTimer *)xb_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

/** 方法三，block回调， 不限制iOS最低版本， 需要手动添加到runloop中，自己控制启动*/
+ (NSTimer *)xb_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(XBSTimerCallbackBlock)block;

/** 方法四，block回调， 不限制iOS最低版本， 系统自动添加到runloop中，创建成功自动启动*/
+ (NSTimer *)xb_scheduledTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(XBSTimerCallbackBlock)block;
@end
NS_ASSUME_NONNULL_END

