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
//        NSLog(@"------------------1");
//        dispatch_queue_t queue = dispatch_get_main_queue();
//        dispatch_async(queue, ^{
//           NSLog(@"主队列异步   %@",[NSThread currentThread]);
//        });
//        NSLog(@"------------------2");
        
        
        
        // 主队列同步
        NSLog(@"------------------1");
        dispatch_queue_t queue2 = dispatch_get_main_queue();
        dispatch_sync(queue2, ^{
            NSLog(@"主队列同步   %@",[NSThread currentThread]);
        });
        NSLog(@"------------------2");


    }
    return 0;
}
