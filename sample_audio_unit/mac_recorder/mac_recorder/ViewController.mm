//
//  ViewController.m
//  audio_unit_record
//
//  Created by yuhao on 2021/11/5.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "mac_recoder.h"

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

- (NSString *) log_file_output_path {
    NSString *pathString =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    if (pathString == nil) {
      pathString = @"";
    } else {
      pathString = [NSString stringWithFormat:@"%@/ims", pathString];
      NSFileManager *fileManager = [NSFileManager defaultManager];
      if (![fileManager fileExistsAtPath:pathString]) {
        if ([fileManager createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:nil] == NO) {
          pathString = @"";
        }
      }
    }
    return pathString;
}

-(void)buttonClick:(id)sender
{
    // macos 10.14以上系统才执行
    if(@available(macos 10.14, *))
    {
        // 请求摄像机授权，v如果是麦克风的话参数是AVMediaTypeAudio.
//        [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
//        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio])
        {
            case AVAuthorizationStatusAuthorized:
            {
                // 已经授权同意.
                [self setupCaptureSession];
                break;
            }
            case AVAuthorizationStatusNotDetermined:
            {
                // 从未处理过授权
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        [self setupCaptureSession];
                    }
                }];
                break;
            }
            case AVAuthorizationStatusDenied:
            {
                // 授权拒绝
                return;
            }
            case AVAuthorizationStatusRestricted:
            {
                // 家长管制等
                return;
            }
        }
    }
    NSLog(@"buttonClick:%@",sender);
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"background.m4a" ofType:nil];
//    NSLog(@"ViewController path:%@",path);
////    AudioUnitRecoder *audioUnitRecoder = new AudioUnitRecoder(48000, path.UTF8String, std::string("/Users/yuhao/qt_record.pcm"));
//    NSString *recordPath = [NSString stringWithFormat:@"%@/qt_record.pcm",[self log_file_output_path]];
//    NSLog(@"ViewController recordPath:%@",recordPath);
//    AudioUnitRecoder *audioUnitRecoder = new AudioUnitRecoder(48000, path.UTF8String, recordPath.UTF8String);
//
//    audioUnitRecoder->startRecording();
}

- (void) setupCaptureSession {
//        NSLog(@"buttonClick:%@",sender);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background.m4a" ofType:nil];
        NSLog(@"ViewController path:%@",path);
    //    AudioUnitRecoder *audioUnitRecoder = new AudioUnitRecoder(48000, path.UTF8String, std::string("/Users/yuhao/qt_record.pcm"));
        NSString *recordPath = [NSString stringWithFormat:@"%@/qt_record.pcm",[self log_file_output_path]];
        NSLog(@"ViewController recordPath:%@",recordPath);
    MacRecoder *macRecoder = new MacRecoder(48000, path.UTF8String, recordPath.UTF8String);
    
        macRecoder->startRecording();
}

@end
