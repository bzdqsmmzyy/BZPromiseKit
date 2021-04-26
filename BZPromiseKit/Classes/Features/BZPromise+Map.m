//
//  BZPromise+Map.m
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/23.
//

#import "BZPromise+Map.h"
#import "BZResult.h"

@implementation BZPromise (Map)

- (BZPromise * _Nonnull (^)(BZPromiseMapBlock))map {
    return ^BZPromise* (BZPromiseMapBlock transform) {
        return self.mapAt(nil, transform);
    };
}

- (BZPromise * _Nonnull (^)(dispatch_queue_t _Nullable, BZPromiseMapBlock))mapAt {
    return ^BZPromise* (dispatch_queue_t q, BZPromiseMapBlock transform) {
        BZPromise *rp = [BZPromise promise];
        self.pipe(^(BZResult * _Nullable r) {
            switch (r.type) {
                case BZResultTypeFulfilled: {
                    BZPNullableQueueAsync(q, ^{
                        BZResult *v = [[BZResult alloc] initWithValue:transform(r.value)];
                        rp.seal(v);
                    });
                }
                    break;
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
