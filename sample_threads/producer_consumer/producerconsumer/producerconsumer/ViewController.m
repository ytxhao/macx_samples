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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cnt = 0;
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
    for (int i = 0; i < 6;i++) {
        self.cnt++;
//        __weak typeof(self)weakSelf = self;
        [self.messagingController put:^(){
//            __strong typeof(weakSelf)strongSelf = weakSelf;
//            [NSThread sleepForTimeInterval:3.0];
            NSString* url = [NSString stringWithFormat:@"https://%@/%d", @"www.baidu.com", i];//开播码率质量
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            [request setTimeoutInterval:10];
            [request setHTTPMethod:@"GET"];
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"NSURLSessionDataTask %@", [NSThread currentThread]);
//                NSLog(@"NSURLSessionDataTask %@", data);
                [NSThread sleepForTimeInterval:4.0];
                NSLog(@"NSURLSessionDataTask %@", response.URL);
                dispatch_semaphore_signal(semaphore);
            }];
            [task resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"test runable block %d", i);
        }];
    }

//    [self.messagingController stop];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
