//
//  IMSActionTrackerRunable.m
//  producerconsumer
//
//  Created by yuhao on 2022/1/20.
//

#import "IMSActionTrackerRunable.h"

@interface IMSActionTrackerRunable()
@property(nonatomic, assign) int retry;
@property(nonatomic, copy) NSString *currentUrl;
@end

@implementation IMSActionTrackerRunable


- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if(self) {
        self.retry = 0;
        self.currentUrl = url;
    }
    NSLog(@"IMSActionTrackerRunable init %@", self);
    return self;
}

- (void)dealloc {
    NSLog(@"IMSActionTrackerRunable dealloc %@", self);
}

#pragma mark - IMSRunnable
- (void)run {
    NSLog(@"IMSActionTrackerRunable run %@", self);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.currentUrl]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode == 200) {
            dispatch_semaphore_signal(semaphore);
        } else {
            
        }
    
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [NSThread sleepForTimeInterval:1.0];
}

@end
