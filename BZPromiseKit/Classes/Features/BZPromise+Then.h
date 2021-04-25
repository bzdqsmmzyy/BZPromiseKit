//
//  BZPromise+Then.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/22.
//

#import "BZPromise.h"

typedef BZPromise* _Nonnull (^_Nonnull BZPromiseThenBlock)(id _Nullable v);
NS_ASSUME_NONNULL_BEGIN
@interface BZPromise (Then)
/// 默认当前线程
@property (nonatomic, readonly) BZPromise* (^then)(BZPromiseThenBlock);

@property (nonatomic, readonly) BZPromise* (^thenAt)(dispatch_queue_t _Nullable, BZPromiseThenBlock);
@end

NS_ASSUME_NONNULL_END
