//
//  BZPromise+Map.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/23.
//

#import "BZPromise+Map.h"
#import "BZResult.h"
#import "BZHelper.h"

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
                    bz_nullable_queue_async(q, ^{
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
