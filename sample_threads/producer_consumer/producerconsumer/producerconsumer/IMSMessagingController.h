//
//  IMSMessagingController.h
//  producerconsumer
//
//  Created by yuhao on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSMessagingController : NSObject

- (void)put:(void(^)(void))runable;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
