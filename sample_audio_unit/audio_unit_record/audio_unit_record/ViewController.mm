//
//  ViewController.m
//  audio_unit_record
//
//  Created by yuhao on 2021/11/5.
//
#import <foundation/Foundation.h>
#import "ViewController.h"
#import "audio_unit_recoder.h"

@interface ViewController()

//@property (nonatomic, strong) NSButton  *pushButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建按钮
    NSButton *pushButton = [[NSButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-44,self.view.frame.size.height/2 + 30, 88, 88)];
    //按钮样式
    pushButton.bezelStyle = NSRoundedBezelStyle;
    //是否显示背景 默认YES
    pushButton.bordered = YES;
    //按钮的Type
     [pushButton setButtonType:NSButtonTypeMomentaryPushIn];
    //设置图片
    pushButton.image = [NSImage imageNamed:@"close.png"];
    //按钮的标题
    [pushButton setTitle:@"按钮"];
    //是否隐藏
    pushButton.hidden = NO;
    //设置按钮的tag
    pushButton.tag = 100;
    //标题居中显示
    pushButton.alignment = NSTextAlignmentCenter;
    //设置背景是否透明
    pushButton.transparent = NO;
    //按钮初始状态
    pushButton.state = NSOffState;
    //按钮是否高亮
    pushButton.highlighted = NO;
    [pushButton  setTarget:self];
    [pushButton setAction:@selector(buttonClick:)];
    //把当前按钮添加到视图上
    [self.view addSubview:pushButton];
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)buttonClick:(id)sender
{
    NSLog(@"buttonClick:%@",sender);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background.m4a" ofType:nil];
    NSLog(@"ViewController path:%@",path);
    AudioUnitRecoder *audioUnitRecoder = new AudioUnitRecoder(48000, path.UTF8String, std::string("/Users/yuhao/qt_record.pcm"));
}


@end
