//
//  ViewController.m
//  producerconsumer
//
//  Created by yuhao on 2022/1/17.
//

#import "ViewController.h"
#import "IMSMessagingController.h"

@interface ViewController()
@property (nonatomic, strong) IMSMessagingController *messagingController;
@property (nonatomic, assign) NSInteger cnt;
@property (nonatomic, copy) NSString *currentUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cnt = 0;
    self.currentUrl = @"test123";
    // Do any additional setup after loading the view.
    self.messagingController = [[IMSMessagingController alloc] init];
    [self setbutton];
}

-(void)setbutton{
    NSButton *button = [[NSButton alloc]init];
    button.frame = CGRectMake(100, 100, 64, 64);
    [button setTitle:@"确认签收"];
    [button setTarget:self];
    [button setAction:@selector(buttonClick)];
    [self.view addSubview:button];
}

-(void)buttonClick{
    NSLog(@"你点击了切换模式");
    if (self.messagingController == nil) {
        self.messagingController = [[IMSMessagingController alloc] init];
    }
    for (int i = 0; i < 100;i++) {
        self.cnt++;
        NSLog(@"buttonClick1 currentUrl:%p currentUrl:%@", self.currentUrl, self.currentUrl);
        NSObject *tmp = [[NSObject alloc]init];
        NSLog(@"NSURLSessionDataTask1 tmp:%p",tmp);
//        __weak typeof(self)weakSelf = self;
        NSLog(@"NSURLSessionDataTask1 url:%p url:%@", self.currentUrl, self.currentUrl);
        [self.messagingController put:^(NSInteger queueSize){
//            [NSThread sleepForTimeInterval:3.0];
            NSLog(@"messagingController run %@ queueSize:%td", [NSThread currentThread], queueSize);
            NSString* url = [NSString stringWithFormat:@"https://%@/%d", @"www.baidu.com", i];//开播码率质量
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            [request setTimeoutInterval:10];
            [request setHTTPMethod:@"GET"];
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                __strong typeof(weakSelf)strongSelf = weakSelf;
//                NSLog(@"NSURLSessionDataTask %@", [NSThread currentThread]);
//                NSLog(@"NSURLSessionDataTask %@", data);
                [NSThread sleepForTimeInterval:1.0];
//                NSLog(@"NSURLSessionDataTask %@", response.URL);
                NSString* url = self.currentUrl;
                self.currentUrl = [url stringByAppendingFormat:@"&_r_job_count_=%d",1];
                NSLog(@"NSURLSessionDataTask2 url:%p url:%@", url, url);
//                int tmp1 =1;
                NSLog(@"NSURLSessionDataTask2 tmp1:%p",tmp);
                dispatch_semaphore_signal(semaphore);
            }];
            [task resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"test runable block %d", i);
            [NSThread sleepForTimeInterval:1.0];
//            NSLog(@"buttonClick2 currentUrl:%p currentUrl:%@", self.currentUrl, self.currentUrl);
        }];
    }

//    [self.messagingController stop];
//    self.messagingController = nil;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
