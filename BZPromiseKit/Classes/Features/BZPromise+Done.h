//
//  BZPromise+Done.h
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/22.
//

#import "BZPromise.h"

typedef void (^_Nonnull BZPromiseDoneBlock)(id _Nullable v);
NS_ASSUME_NONNULL_BEGIN

@interface BZPromise (Done)
/// 默认在主线程
@property (nonatomic, readonly) BZPromise* (^done)(BZPromiseDoneBlock);

@property (nonatomic, readonly) BZPromise* (^doneAt)(dispatch_queue_t _Nullable, BZPromiseDoneBlock);

@end

NS_ASSUME_NONNULL_END
