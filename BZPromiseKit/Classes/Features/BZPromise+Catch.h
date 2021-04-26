//
//  BZPromise+Catch.h
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/22.
//

#import "BZPromise.h"

typedef void (^_Nonnull BZPromiseCatchBlock)(NSError *_Nonnull e);

NS_ASSUME_NONNULL_BEGIN

@interface BZPromise (Catch)
/// 默认在主线程
@property (nonatomic, readonly) void (^catchOf)(BZPromiseCatchBlock);

@property (nonatomic, readonly) void (^catchAt)(dispatch_queue_t _Nullable, BZPromiseCatchBlock);

@end

NS_ASSUME_NONNULL_END
