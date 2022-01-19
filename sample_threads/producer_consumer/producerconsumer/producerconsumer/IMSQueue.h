//
//  IMSQueue.h
//  producerconsumer
//
//  Created by yuhao on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSQueue : NSObject
- (void)put:(id)object;
- (id)take;
- (NSInteger)count;
- (void)clear;
@end

NS_ASSUME_NONNULL_END
