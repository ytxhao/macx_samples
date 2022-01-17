//
//  ViewController.m
//  producerconsumer
//
//  Created by yuhao on 2022/1/17.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
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
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
