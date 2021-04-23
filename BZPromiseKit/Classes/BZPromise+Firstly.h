//
//  BZPromise+Firstly.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/23.
//

#import "BZPromise.h"

typedef BZPromise* _Nonnull (^_Nonnull BZPromiseFirstlyBlock)(void);

NS_ASSUME_NONNULL_BEGIN
BZPromise *firstly(BZPromiseFirstlyBlock);
NS_ASSUME_NONNULL_END
