//
//  BZPromise+Done.m
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/22.
//

#import "BZPromise+Done.h"
#import "BZResult.h"

@implementation BZPromise (Done)
- (BZPromise * _Nonnull (^)(BZPromiseDoneBlock))done {
    return ^BZPromise* (BZPromiseDoneBlock body) {
        return self.doneAt(dispatch_get_main_queue(), body);
    };
}

- (BZPromise * _Nonnull (^)(dispatch_queue_t _Nullable, BZPromiseDoneBlock))doneAt {
    return ^BZPromise* (dispatch_queue_t q, BZPromiseDoneBlock body) {
        BZPromise *rp = [BZPromise promise];
        self.pipe(^(BZResult * _Nullable r) {
            switch (r.type) {
                case BZResultTypeFulfilled: {
                    BZPNullableQueueAsync(q, ^{
                        body(r.value);
                        rp.seal(r);
                    });
                    break;
                }
                case BZResultTypeRejected:
                    rp.seal(r);
                    break;
                default:
                    break;
            }
        });
        return rp;
    };
}
@end
