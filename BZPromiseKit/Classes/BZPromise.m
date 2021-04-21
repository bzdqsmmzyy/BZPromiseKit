//
//  BZPromise.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/21.
//

#import "BZPromise.h"
#import "BZResolver.h"

@interface BZPromise ()
@property (nonatomic, strong) BZBox *box;
@end
@implementation BZPromise
+ (instancetype)promiseWithValue:(id)value {
    BZPromise *p = [[BZPromise alloc] init];
    BZResult *r = [[BZResult alloc] initWithValue:value];
    p.box = [[BZSealedBox alloc] initWithValue:r];
    return p;
}

+ (instancetype)promiseWithError:(NSError *)error {
    BZPromise *p = [[BZPromise alloc] init];
    BZResult *r = [[BZResult alloc] initWithError:error];
    p.box = [[BZSealedBox alloc] initWithValue:r];
    return p;
}

+ (instancetype)promiseWithResolver:(void (^)(BZResolver * _Nonnull))body {
    BZPromise *p = [[BZPromise alloc] init];
    p.box = [[BZEmptyBox alloc] init];
    BZResolver *resolver = [[BZResolver alloc] initWithBox:p.box];
    !body ?: body(resolver);
    return p;
}

- (BZResult *)result {
    switch (self.box.status) {
        case BZBoxSealantStatusPending:
            return nil;
        case BZBoxSealantStatusResolved:
            return self.box.value;
        default:
            break;
    }
    return nil;
}

- (void (^)(BZBoxValueHandle))pipe {
    return ^void (BZBoxValueHandle to){
        switch (self.box.status) {
            case BZBoxSealantStatusPending:
                self.box.append(to);
                break;
            case BZBoxSealantStatusResolved:
                !to ?: to(self.box.value);
                break;
            default:
                break;
        }
    };
}
@end
