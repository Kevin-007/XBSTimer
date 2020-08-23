
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XBSWeakProxy : NSProxy
/** weak target*/
@property (nonatomic, weak) id target;

/** init proxy by target*/
+ (instancetype)timerProxyWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
