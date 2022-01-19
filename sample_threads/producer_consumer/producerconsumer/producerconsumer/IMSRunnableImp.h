//
//  IMSRunnableImp.h
//  producerconsumer
//
//  Created by yuhao on 2022/1/19.
//

#import <Foundation/Foundation.h>
#import "IMSRunnable.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMSRunnableImp : NSObject <IMSRunnable>
- (id)initWithBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
