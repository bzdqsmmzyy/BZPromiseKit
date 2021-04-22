//
//  BZPromise+Done.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/22.
//

#import "BZPromise.h"

typedef void (^_Nonnull BZPromiseDoneBlock)(id _Nullable v);
NS_ASSUME_NONNULL_BEGIN

@interface BZPromise (Done)

@property (nonatomic, readonly) BZPromise* (^done)(BZPromiseDoneBlock);

@end

NS_ASSUME_NONNULL_END
