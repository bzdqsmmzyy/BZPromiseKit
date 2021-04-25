//
//  BZPromise+Convenience.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/23.
//

#import "BZPromise.h"

typedef BZPromise* _Nonnull (^_Nonnull BZPromiseFirstlyBlock)(void);

NS_ASSUME_NONNULL_BEGIN
BZPromise *BZPFirstly(BZPromiseFirstlyBlock);

BZPromise *BZPRace(NSArray <BZPromise *> *promises);

BZPromise *BZPWhen(NSArray <BZPromise *> *promises);
NS_ASSUME_NONNULL_END
