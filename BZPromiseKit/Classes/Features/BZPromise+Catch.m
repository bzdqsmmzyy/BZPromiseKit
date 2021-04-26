//
//  BZPromise+Catch.m
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/22.
//

#import "BZPromise+Catch.h"
#import "BZResult.h"

@implementation BZPromise (Catch)
- (void (^)(BZPromiseCatchBlock))catchOf {
    return ^void (BZPromiseCatchBlock body) {
        self.catchAt(dispatch_get_main_queue(), body);
    };
}

- (void (^)(dispatch_queue_t _Nullable, BZPromiseCatchBlock))catchAt {
    return ^void (dispatch_queue_t q, BZPromiseCatchBlock body) {
        self.pipe(^(BZResult * _Nullable v) {
            if (v.type == BZResultTypeRejected) {
                BZPNullableQueueAsync(q, ^{
                    body(v.error);
                });
            }
        });
    };
}
@end
