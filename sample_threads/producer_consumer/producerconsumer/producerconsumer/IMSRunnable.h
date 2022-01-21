//
//  IMSRunnable.h
//  producerconsumer
//
//  Created by yuhao on 2022/1/19.
//

#import <Foundation/Foundation.h>

@protocol IMSRunnable <NSObject>
@optional
- (void)setRunnableQueueSize:(NSInteger)size;

@required
- (void)run;

@end

