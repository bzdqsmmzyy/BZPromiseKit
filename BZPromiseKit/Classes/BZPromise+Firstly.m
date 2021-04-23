//
//  BZPromise+Firstly.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/23.
//

#import "BZPromise+Firstly.h"

BZPromise *firstly(BZPromiseFirstlyBlock body) {
    BZPromise *rp = [BZPromise promise];
    body().pipe(^(BZResult * _Nullable v) {
        rp.seal(v);
    });
    return rp;
}
