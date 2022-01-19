//
//  IMSMessagingController.m
//  producerconsumer
//
//  Created by yuhao on 2022/1/18.
//

#import "IMSMessagingController.h"
#import "IMSQueue.h"
#import "IMSRunnableImp.h"

@interface IMSMessagingController()
@property (nonatomic, strong) NSThread *controllerThread;
@property (nonatomic, strong) IMSQueue *queuedCommands;
@property (nonatomic, assign) BOOL stopped;
@end

@implementation IMSMessagingController

- (instancetype)init {
    NSLog(@"IMSMessagingController init");
    self = [super init];
    if (self) {
        self.stopped = NO;
        self.queuedCommands = [[IMSQueue alloc] init];
        self.controllerThread = [[NSThread alloc] initWithTarget:self selector:@selector(runInBackground) object:nil];
        [self.controllerThread setName:@"IMSMessagingController"];
        [self.controllerThread start];
    }
    return self;
}

- (void)runInBackground {
    while (!self.stopped) {
        NSLog(@"IMSMessagingController size:%td",[self.queuedCommands count]);
        id<IMSRunnable> command = [self.queuedCommands take];
        [command run];
    }
}

- (void)put:(void(^)(void))runable{
    IMSRunnableImp *runnableImp = [[IMSRunnableImp alloc] initWithBlock:runable];
    [self.queuedCommands put:runnableImp];
}

- (void)stop {
    NSLog(@"IMSMessagingController stop");
    [self.queuedCommands clear];
    self.stopped = YES;
//    [self.controllerThread exit];
}

- (void)dealloc {
    NSLog(@"IMSMessagingController dealloc");
}

@end
