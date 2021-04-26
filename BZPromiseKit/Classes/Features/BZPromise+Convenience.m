//
//  BZPromise+Firstly.m
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/23.
//

#import "BZPromise+Convenience.h"
#import "BZResolver.h"
#import "BZResult.h"

#import <libkern/OSAtomic.h>

BZPromise *BZPFirstly(BZPromiseFirstlyBlock body) {
    BZPromise *rp = [BZPromise promise];
    body().pipe(^(BZResult * _Nullable v) {
        rp.seal(v);
    });
    return rp;
}

BZPromise *BZPRace(NSArray <BZPromise *> *promises) {
    if (!promises.count) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"bad input"};
        NSError *error = [NSError errorWithDomain:BZPErrorDomian
                                             code:BZPErrorCodeBadInput
                                         userInfo:userInfo];
        return [BZPromise promiseWithError:error];
    }
    BZPromise *rp = [BZPromise promise];
    for (BZPromise *promise in promises) {
        promise.pipe(^(BZResult * _Nullable v) {
            rp.seal(v);
        });
    }
    return rp;
}

BZPromise *BZPWhen(NSArray <BZPromise *> *promises) {
    if (!promises.count) {
        return [BZPromise promiseWithValue:@[]];
    }
    __block int32_t countdown = (int32_t)promises.count;
    
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:(int64_t)countdown];
    progress.pausable = NO;
    progress.cancellable = NO;
    
    return [BZPromise promiseWithResolver:^(BZResolver * _Nonnull resolver) {
        for (BZPromise *promise in promises) {
            promise.pipe(^(BZResult * _Nullable v) {
                if (progress.fractionCompleted >= 1) {
                    return;
                }
                if (v.type == BZResultTypeRejected) {
                    progress.completedUnitCount = progress.totalUnitCount;
                    resolver.reject(v.error);
                } else if (OSAtomicDecrement32(&countdown) == 0) { // 原子方式递减
                    progress.completedUnitCount = progress.totalUnitCount;
                    
                    NSMutableArray *results = [NSMutableArray array];
                    for (BZPromise *promise in promises) {
                        id value = promise.result.value ?: [NSNull null];
                        [results addObject:value];
                    }
                    resolver.fulfill(results);
                } else {
                    progress.completedUnitCount++;
                }
            });
        }
    }];
}

BZPromise *BZAfter(NSTimeInterval seconds) {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)seconds * NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    BZPromise *rp = [BZPromise promise];
    dispatch_after(when, queue, ^{
        rp.seal(nil);
    });
    return rp;
}
