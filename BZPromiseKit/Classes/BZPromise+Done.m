//
//  BZPromise+Done.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/22.
//

#import "BZPromise+Done.h"
#import "BZResult.h"

@implementation BZPromise (Done)
- (BZPromise * _Nonnull (^)(BZPromiseDoneBlock))done {
    return ^BZPromise* (BZPromiseDoneBlock body) {
        BZPromise *rp = [BZPromise promise];
        self.pipe(^(BZResult * _Nullable r) {
            switch (r.type) {
                case BZResultTypeFulfilled:
                    body(r.value);
                    rp.seal(r);
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
