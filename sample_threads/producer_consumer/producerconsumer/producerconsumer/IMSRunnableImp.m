//
//  IMSRunnableImp.m
//  producerconsumer
//
//  Created by yuhao on 2022/1/19.
//

#import "IMSRunnableImp.h"

@interface IMSRunnableImp()
@property (nonatomic, assign) NSInteger queueSize;
@property (nonatomic, copy) void(^runBlock)(void);
@property (nonatomic, copy) void(^runQueueSizeBlock)(NSInteger);
@end

@implementation IMSRunnableImp

- (id)initWithBlock:(void(^)(void))block
{
    self = [super init];
    if(self)
    {
        self.queueSize = 0;
        self.runBlock = block;
    }
    NSLog(@"IMSRunnableImp init %@", self);
    return self;
}

- (id)initWithQueueSizeBlock:(void(^)(NSInteger))block {
    self = [super init];
    if(self)
    {
        self.queueSize = 0;
        self.runQueueSizeBlock = block;
    }
    NSLog(@"IMSRunnableImp init %@", self);
    return self;
}

- (void)dealloc {
    NSLog(@"IMSRunnableImp dealloc %@", self);
}

#pragma mark - IMSRunnable
- (void)run {
    if (self.runBlock != nil) {
        NSLog(@"IMSRunnableImp runBlock %@", self);
        self.runBlock();
    }
    
    if (self.runQueueSizeBlock != nil) {
        NSLog(@"IMSRunnableImp runQueueSizeBlock %@", self);
        self.runQueueSizeBlock(self.queueSize);
    }
}

- (void)setRunnableQueueSize:(NSInteger)size {
    self.queueSize = size;
}

@end
