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
    for (int i = 0; i < 5;i++) {
        self.cnt++;
//        __weak typeof(self)weakSelf = self;
        [self.messagingController put:^(){
//            __strong typeof(weakSelf)strongSelf = weakSelf;
            [NSThread sleepForTimeInterval:3.0];
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
