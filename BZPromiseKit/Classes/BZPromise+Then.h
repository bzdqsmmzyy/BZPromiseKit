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

@property (nonatomic, readonly) BZPromise* (^then)(BZPromiseThenBlock);

@end

NS_ASSUME_NONNULL_END
