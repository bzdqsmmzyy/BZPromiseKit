//
//  BZPromise+Catch.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/22.
//

#import "BZPromise+Catch.h"
#import "BZResult.h"

@implementation BZPromise (Catch)
- (void (^)(BZPromiseCatchBlock))catchOf {
    return ^void (BZPromiseCatchBlock body) {
        self.pipe(^(BZResult * _Nullable v) {
            if (v.type == BZResultTypeRejected) {
                body(v.error);
            }
        });
    };
}
@end
