//
//  main.m
//  multithread
//
//  Created by yuhao on 2021/12/15.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        
        while (true) {
            NSLog(@"------------------1");
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
               NSLog(@"主队列异步   %@",[NSThread currentThread]);
            });
            NSLog(@"------------------2");
            sleep(100);
        }
        
        
        // 主队列同步
//        NSLog(@"------------------1");
//        dispatch_queue_t queue2 = dispatch_get_main_queue();
//        dispatch_sync(queue2, ^{
//            NSLog(@"主队列同步   %@",[NSThread currentThread]);
//        });
//        NSLog(@"------------------2");
//        NSLog(@"------------------1");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
//            NSLog(@"主队列 dispatch_after  %@",[NSThread currentThread]);
//        });
//        NSLog(@"------------------2");


//        sleep(10);
    }
    return 0;
}
