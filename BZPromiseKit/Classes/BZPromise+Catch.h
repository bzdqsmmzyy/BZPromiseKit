//
//  BZPromise+Catch.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/22.
//

#import "BZPromise.h"

typedef void (^_Nonnull BZPromiseCatchBlock)(NSError *_Nonnull e);

NS_ASSUME_NONNULL_BEGIN

@interface BZPromise (Catch)

@property (nonatomic, readonly) void (^catchOf)(BZPromiseCatchBlock);

@end

NS_ASSUME_NONNULL_END
