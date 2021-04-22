//
//  BZPromise+Then.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/22.
//

#import "BZPromise+Then.h"
#import "BZResult.h"

@implementation BZPromise (Then)
- (BZPromise * _Nonnull (^)(BZPromiseThenBlock))then {
    return ^BZPromise* (BZPromiseThenBlock body) {
        BZPromise *rp = [BZPromise promise];
        self.pipe(^(BZResult * _Nullable r) {
            switch (r.type) {
                case BZResultTypeFulfilled:
                {
                    BZPromise *rv = body(r.value);
                    if (rv == rp) {
                        NSError *error = [NSError errorWithDomain:@"com.bzpromisekit.Domain"
                                                             code:10001
                                                         userInfo:@{NSLocalizedDescriptionKey : @"A handler returned its own promis"}];
                        BZResult *r = [[BZResult alloc] initWithError:error];
                        rp.seal(r);
                        return;
                    }
                    rv.pipe(^(BZResult * _Nullable v) {
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
