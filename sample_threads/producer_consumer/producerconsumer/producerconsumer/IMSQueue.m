//
//  IMSQueue.m
//  producerconsumer
//
//  Created by yuhao on 2022/1/18.
//

#import "IMSQueue.h"

#define DEFAULT_INITIAL_CAPACITY 200
@interface IMSQueue()
@property (nonatomic, strong) NSMutableArray *queue;
//@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSCondition *notEmpty;
@property (nonatomic, assign) NSInteger size;


@end

@implementation IMSQueue

- (id)init
{
    NSLog(@"IMSQueue init");
    self = [super init];
    if(self)
    {
        self.queue = [[NSMutableArray alloc] init];
//        self.lock = [[NSLock alloc] init];
        self.notEmpty = [[NSCondition alloc] init];
        self.size = 0;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"IMSQueue dealloc");
}

//- (void)enqueue:(id)object {
//    [self.queue addObject:object];
//    self.count = self.queue.count;
//}

- (BOOL)offer:(id)object {
    BOOL ret = NO;
    if (object == nil) {
        @throw [NSException
            exceptionWithName:NSObjectNotAvailableException
            reason:@"input object is nil" userInfo:nil];
    }
    NSCondition *lock = self.notEmpty;
    [lock lock];
    if (self.queue.count < DEFAULT_INITIAL_CAPACITY) {
        [self.queue addObject:object];
        self.size = self.queue.count;
        ret = YES;
        [self.notEmpty signal];
    } else {
        ret = NO;
    }
    [lock unlock];
    return ret;
}

- (id)dequeue {
    id obj = nil;
    if(self.queue.count > 0)
    {
        obj = [self.queue objectAtIndex:0];
        [self.queue removeObjectAtIndex:0];
        self.size = self.queue.count;
    }
    return obj;
}

- (void)put:(id)object {
    [self offer:object];
}

- (id)take {
    id result;
    NSCondition *lock = self.notEmpty;
    [lock lock];
    while ((result = [self dequeue]) == nil) {
        [self.notEmpty wait];
    }
    [lock unlock];
    
    return result;
}

- (NSInteger)count {
    NSInteger ret = 0;
    NSCondition *lock = self.notEmpty;
    [lock lock];
    ret = self.size;
    [lock unlock];
    return ret;
}

- (void)clear {
    NSCondition *lock = self.notEmpty;
    [lock lock];
    [self.queue removeAllObjects];
    self.size = 0;
    [lock unlock];
}

@end
