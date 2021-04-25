//
//  BZPromise+Map.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/23.
//

#import "BZPromise.h"

typedef id _Nullable (^_Nonnull BZPromiseMapBlock)(id _Nullable v);

NS_ASSUME_NONNULL_BEGIN
@interface BZPromise (Map)
/// 默认当前线程
@property (nonatomic, readonly) BZPromise* (^map)(BZPromiseMapBlock);

@property (nonatomic, readonly) BZPromise* (^mapAt)(dispatch_queue_t _Nullable, BZPromiseMapBlock);

@end
NS_ASSUME_NONNULL_END
