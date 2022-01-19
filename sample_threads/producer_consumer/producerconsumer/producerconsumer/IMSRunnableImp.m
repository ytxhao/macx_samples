//
//  IMSRunnableImp.m
//  producerconsumer
//
//  Created by yuhao on 2022/1/19.
//

#import "IMSRunnableImp.h"

@interface IMSRunnableImp()
@property (nonatomic, copy) void(^runBlock)(void);
@end

@implementation IMSRunnableImp

- (id)initWithBlock:(void(^)(void))block
{
    self = [super init];
    if(self)
    {
        self.runBlock = block;
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
}

@end
