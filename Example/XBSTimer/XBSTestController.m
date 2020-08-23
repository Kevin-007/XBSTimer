//
//  XBSTestController.m
//  XBSTimer_Example
//
//  Created by Kevin on 2020/8/23.
//  Copyright © 2020 Aniyang. All rights reserved.
//

#import "XBSTestController.h"
#import <XBSTimer.h>

@interface XBSTestController ()

//NSTimer
/** timer1*/
@property (nonatomic, strong) NSTimer *timer1;
/** timer2*/
@property (nonatomic, strong) NSTimer *timer2;
/** timer3*/
@property (nonatomic, strong) NSTimer *timer3;
/** timer4*/
@property (nonatomic, strong) NSTimer *timer4;

//CADisplayLink
/**link timer1*/
@property (nonatomic, strong) CADisplayLink *linkTimer1;
/** link timer2*/
@property (nonatomic, strong) CADisplayLink *linkTimer2;
/** link timer3*/
@property (nonatomic, strong) CADisplayLink *linkTimer3;

//XBSGCDTimer
/**GCD timer1*/
@property (nonatomic, strong) XBSGCDTimer *gcdTimer1;
/**GCD  timer2*/
@property (nonatomic, strong) XBSGCDTimer *gcdTimer2;
/**GCD  timer3*/
@property (nonatomic, strong) XBSGCDTimer *gcdTimer3;
/**GCD  timer4*/
@property (nonatomic, strong) XBSGCDTimer *gcdTimer4;

@end

@implementation XBSTestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self test_XBSGCDTimer];
    
//    [self test_NSTimer];
//
//    [self test_CADisplayLink];

}

- (void)test_NSTimer{
    
     //need add runloop, and start fire
    _timer1 = [NSTimer xb_timerWithTimeInterval:1 target:self selector:@selector(timer_Action1) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer1 forMode:NSRunLoopCommonModes];
    [_timer1 fire];
    
    
    // auto fire
    _timer2 = [NSTimer xb_scheduledTimerWithTimeInterval:2 target:self selector:@selector(timer_Action2) userInfo:nil repeats:YES];
    
    
    //block callback, need add runloop, and start fire
    _timer3 = [NSTimer xb_timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer3");
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer3 forMode:NSRunLoopCommonModes];
    [_timer3 fire];
    
    
    //block callback, auto fire
    _timer4 = [NSTimer xb_scheduledTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer4");
    }];
    
    //change mode, default is NSDefaultRunLoopMode
    [[NSRunLoop currentRunLoop] addTimer:_timer4 forMode:NSRunLoopCommonModes];
    
    
    
}

- (void)test_CADisplayLink{
    
    //the same as system api, only destroy retain cycle
    _linkTimer1 = [CADisplayLink xb_displayLinkWithTarget:self selector:@selector(link_Action1)];
    _linkTimer1.frameInterval = 60;
    
    [_linkTimer1 addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //destroy retain cycle and auto fire
    _linkTimer2 = [CADisplayLink xb_scheduledDisplayLinkWithTarget:self selector:@selector(link_Action2)];
    _linkTimer2.frameInterval = 60;
    
    //block call back
    _linkTimer3 = [CADisplayLink xb_scheduledDisplayLinkWithBlock:^(CADisplayLink * _Nonnull link) {
        NSLog(@"linkTimer3");
    }];
    _linkTimer3.frameInterval = 60;
    
    
}


- (void)test_XBSGCDTimer{
    //main queue, NO repeats
    NSLog(@"gcdTimer1 start");
    _gcdTimer1 = [XBSGCDTimer xb_GCDTimerWithSartTime:0 interval:0 queue:nil repeats:NO block:^(XBSGCDTimer * _Nonnull timer) {
        NSLog(@"gcdTimer1,%@", [NSThread currentThread]);
    }];
    
    //need fire
    [_gcdTimer1 fire];
    
    
    //global queue, repeats
    NSLog(@"gcdTimer2 start");
    _gcdTimer2 = [XBSGCDTimer xb_scheduledGCDTimerWithSartTime:2 interval:1 queue:dispatch_get_global_queue(0, 0) repeats:YES block:^(XBSGCDTimer *timer) {
        NSLog(@"gcdTimer2,%@", [NSThread currentThread]);
    }];
    
    
    //global queue, repeats
    NSLog(@"gcdTimer3 start");
    _gcdTimer3 = [XBSGCDTimer xb_GCDTimerWithTarget:self selector:@selector(gcdTimerAction1) SartTime:0 interval:2 queue:dispatch_get_global_queue(0, 0) repeats:YES];

    //need fire
    [_gcdTimer3 fire];

    //main queue, NO repeats
    NSLog(@"gcdTimer4 start");
    _gcdTimer4 = [XBSGCDTimer xb_scheduledGCDTimerWithTarget:self selector:@selector(gcdTimerAction2) SartTime:6 interval:1 queue:dispatch_get_main_queue() repeats:NO];
    
     __weak typeof(self) weakSelf = self;
    [XBSGCDTimer xb_scheduledGCDTimerWithSartTime:2 interval:1 queue:dispatch_get_global_queue(0, 0) repeats:YES block:^(XBSGCDTimer *timer) {
        if (!weakSelf) {
            [timer invalidate];
             NSLog(@"stop");
            return;
        }
         NSLog(@"gcdTimer5,%@", [NSThread currentThread]);
     }];
    
}


#pragma mark - Event for CADisplayLink
- (void)link_Action1{
    NSLog(@"%s", __func__);
}

- (void)link_Action2{
    NSLog(@"%s", __func__);
}


#pragma mark - Event for NSTimer
- (void)timer_Action1{
    NSLog(@"%s", __func__);
}

- (void)timer_Action2{
    NSLog(@"%s", __func__);
}


#pragma mark - Event for GCDTimer
- (void)gcdTimerAction1{
    NSLog(@"%s", __func__);
}

- (void)gcdTimerAction2{
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self.timer1 invalidate];
    [self.timer2 invalidate];
    [self.timer3 invalidate];
    [self.timer4 invalidate];
    
    
    [self.linkTimer1 invalidate];
    [self.linkTimer2 invalidate];
    [self.linkTimer3 invalidate];
    
    [self.gcdTimer1 invalidate];
    [self.gcdTimer2 invalidate];
    [self.gcdTimer3 invalidate];
    [self.gcdTimer4 invalidate];
}

@end
